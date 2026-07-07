# frozen_string_literal: true

require "digest"
require "fileutils"
require "json"
require "net/http"
require "open-uri"
require "pathname"
require "tempfile"
require "uri"
require "yaml"

module HomebrewTap
  class Error < StandardError; end

  module_function

  def repo_root
    Pathname.new(__dir__).join("../../..").expand_path
  end

  def normalize_version(version)
    version.to_s.sub(/^v/, "")
  end

  def tag_for(package, version)
    prefix = package.fetch("version_prefix", "v")
    "#{prefix}#{normalize_version(version)}"
  end

  def expand_template(value, version:, tag:, filename: nil)
    value.to_s
         .gsub("{version}", version)
         .gsub("{tag}", tag)
         .gsub("{filename}", filename.to_s)
  end

  def expected_asset_filenames(package, version, tag: nil)
    tag ||= tag_for(package, version)
    package.fetch("assets").map do |_asset_key, asset_config|
      expand_template(asset_config.fetch("filename"), version: version, tag: tag)
    end
  end

  def missing_release_assets(release:, package:, version:)
    assets_by_name = release.fetch("assets").to_h { |asset| [asset.fetch("name"), asset] }
    expected_asset_filenames(package, version, tag: tag_for(package, version)).reject do |filename|
      assets_by_name.key?(filename)
    end
  end

  def sha256_file(path)
    Digest::SHA256.file(path).hexdigest
  end

  def current_version(path)
    content = File.read(path)
    matches = content.scan(/^\s*version\s+"([^"]+)"/)
    raise Error, "expected exactly one version line in #{path}, found #{matches.length}" unless matches.length == 1

    normalize_version(matches[0][0])
  end

  class Manifest
    attr_reader :path, :packages

    def initialize(path)
      @path = Pathname.new(path)
      raw = YAML.safe_load(File.read(@path), aliases: false)
      @packages = raw.fetch("packages")
    rescue KeyError => e
      raise Error, "invalid manifest #{path}: missing #{e.key}"
    rescue Psych::Exception => e
      raise Error, "invalid manifest #{path}: #{e.message}"
    end

    def package(name)
      packages.fetch(name) { raise Error, "package not found in manifest: #{name}" }
    end

    def each_package(&block)
      packages.each_pair(&block)
    end

    def package_for_path(path)
      normalized = path.to_s
      packages.find { |_name, package| package.fetch("path") == normalized }
    end

    def validate!(root: HomebrewTap.repo_root)
      packages.each do |name, package|
        validate_package!(name, package, root: root)
      end
    end

    private

    def validate_package!(name, package, root:)
      %w[type source_repo path assets].each do |field|
        raise Error, "#{name}: missing #{field}" unless package.key?(field)
      end

      type = package.fetch("type")
      raise Error, "#{name}: type must be formula or cask" unless %w[formula cask].include?(type)

      file = root.join(package.fetch("path"))
      raise Error, "#{name}: package file does not exist: #{file}" unless file.file?

      HomebrewTap.current_version(file)

      assets = package.fetch("assets")
      raise Error, "#{name}: assets must be a non-empty map" unless assets.is_a?(Hash) && assets.any?

      filenames = assets.map do |asset_name, asset|
        raise Error, "#{name}.#{asset_name}: missing filename" unless asset["filename"]

        asset.fetch("filename")
      end
      duplicates = filenames.group_by(&:itself).select { |_filename, values| values.length > 1 }.keys
      raise Error, "#{name}: duplicate asset filenames: #{duplicates.join(", ")}" if duplicates.any?
    end
  end

  class GitHubClient
    API = "https://api.github.com"

    def initialize(token: ENV["GH_TOKEN"] || ENV["GITHUB_TOKEN"] || ENV["GH_PAT"])
      @token = token.to_s.empty? ? nil : token
    end

    def release_by_tag(repo, tag)
      request_json("/repos/#{repo}/releases/tags/#{URI.encode_www_form_component(tag)}")
    end

    def latest_release(repo, allow_prerelease: false)
      releases = request_json("/repos/#{repo}/releases?per_page=30")
      releases.find do |release|
        !release.fetch("draft") && (allow_prerelease || !release.fetch("prerelease"))
      end
    end

    def download(url, destination)
      attempts = 0
      begin
        attempts += 1
        download_once(url, destination)
      rescue Error
        raise
      rescue StandardError => e
        retry if attempts < 3

        raise Error, "failed to download #{url}: #{e.class}: #{e.message}"
      end
    end

    private

    def download_once(url, destination)
      uri = URI(url)
      5.times do
        request = Net::HTTP::Get.new(uri)
        add_headers(request)
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
          response = http.request(request)
          case response
          when Net::HTTPSuccess
            File.binwrite(destination, response.body)
            return destination
          when Net::HTTPRedirection
            uri = URI(response.fetch("location"))
            next
          else
            raise Error, "failed to download #{url}: HTTP #{response.code} #{response.message}"
          end
        end
      end
      raise Error, "too many redirects while downloading #{url}"
    end

    def request_json(path)
      attempts = 0
      begin
        attempts += 1
        uri = URI("#{API}#{path}")
        request = Net::HTTP::Get.new(uri)
        add_headers(request)
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
        raise Error, "GitHub API #{path} failed: HTTP #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise Error, "GitHub API #{path} returned invalid JSON: #{e.message}"
      rescue Error
        raise
      rescue StandardError => e
        retry if attempts < 3

        raise Error, "GitHub API #{path} failed: #{e.class}: #{e.message}"
      end
    end

    def add_headers(request)
      request["Accept"] = "application/vnd.github+json"
      request["X-GitHub-Api-Version"] = "2022-11-28"
      request["Authorization"] = "Bearer #{@token}" if @token
      request["User-Agent"] = "samzong-homebrew-tap-updater"
    end
  end

  class PackageEditor
    attr_reader :path

    def initialize(path)
      @path = Pathname.new(path)
      @lines = File.readlines(@path, chomp: true)
    end

    def content
      @lines.join("\n") + "\n"
    end

    def write!
      File.write(@path, content)
    end

    def replace_version!(version)
      matches = @lines.each_index.select { |index| @lines[index] =~ /^\s*version\s+"[^"]+"/ }
      raise Error, "expected exactly one version line in #{@path}, found #{matches.length}" unless matches.length == 1

      index = matches.first
      @lines[index] = @lines[index].sub(/version\s+"[^"]+"/, "version \"#{version}\"")
    end

    def update_asset!(asset, sha256:, url:)
      if asset["block"]
        update_asset_in_block!(asset.fetch("block"), asset, sha256: sha256, url: url)
      else
        update_asset_near_url!(asset, sha256: sha256, url: url)
      end
    end

    def extract_sha(asset)
      if asset["block"]
        range = block_range(asset.fetch("block"))
        sha_indexes = range.select { |index| @lines[index] =~ /sha256\s+"([0-9a-fA-F]{64})"/ }
        raise Error, "#{@path}: expected exactly one sha256 in block #{asset.fetch("block")}, found #{sha_indexes.length}" unless sha_indexes.length == 1

        @lines[sha_indexes.first].match(/sha256\s+"([0-9a-fA-F]{64})"/)[1].downcase
      else
        url_index = find_url_index(asset)
        sha_index = find_following_sha_index(url_index)
        @lines[sha_index].match(/sha256\s+"([0-9a-fA-F]{64})"/)[1].downcase
      end
    end

    private

    def update_asset_in_block!(block_name, asset, sha256:, url:)
      range = block_range(block_name)
      sha_indexes = range.select { |index| @lines[index] =~ /sha256\s+"[0-9a-fA-F]{64}"/ }
      raise Error, "#{@path}: expected exactly one sha256 in block #{block_name}, found #{sha_indexes.length}" unless sha_indexes.length == 1

      @lines[sha_indexes.first] = @lines[sha_indexes.first].sub(/sha256\s+"[0-9a-fA-F]{64}"/, "sha256 \"#{sha256}\"")

      url_indexes = range.select { |index| @lines[index].include?("url \"") }
      if url_indexes.length == 1 && should_update_url?(@lines[url_indexes.first], asset)
        @lines[url_indexes.first] = replace_url_literal(@lines[url_indexes.first], url)
      end
    end

    def update_asset_near_url!(asset, sha256:, url:)
      url_index = find_url_index(asset)
      @lines[url_index] = replace_url_literal(@lines[url_index], url) if should_update_url?(@lines[url_index], asset)

      sha_index = find_following_sha_index(url_index)
      @lines[sha_index] = @lines[sha_index].sub(/sha256\s+"[0-9a-fA-F]{64}"/, "sha256 \"#{sha256}\"")
    end

    def block_range(block_name)
      start = nil
      indent = nil
      @lines.each_with_index do |line, index|
        next unless line =~ /^(\s*)#{Regexp.escape(block_name)}\s+do\b/

        start = index
        indent = Regexp.last_match(1)
        break
      end
      raise Error, "#{@path}: block not found: #{block_name}" unless start

      finish = ((start + 1)...@lines.length).find { |index| @lines[index] =~ /^#{Regexp.escape(indent)}end\s*$/ }
      raise Error, "#{@path}: block #{block_name} has no matching end" unless finish

      (start..finish)
    end

    def find_url_index(asset)
      patterns = [asset["url_match"], asset["filename"]].compact.map(&:to_s).reject(&:empty?)
      matches = @lines.each_index.select do |index|
        @lines[index].include?("url \"") && patterns.any? { |pattern| @lines[index].include?(pattern) }
      end
      raise Error, "#{@path}: expected exactly one url for #{patterns.join(" or ")}, found #{matches.length}" unless matches.length == 1

      matches.first
    end

    def find_following_sha_index(url_index)
      matches = []
      ((url_index + 1)...@lines.length).each do |index|
        break if @lines[index].include?("url \"")
        break if @lines[index] =~ /^\s*end\s*$/

        matches << index if @lines[index] =~ /sha256\s+"[0-9a-fA-F]{64}"/
      end
      raise Error, "#{@path}: expected exactly one sha256 after url on line #{url_index + 1}, found #{matches.length}" unless matches.length == 1

      matches.first
    end

    def should_update_url?(line, asset)
      asset["update_url"] == true || !line.include?('#{version}')
    end

    def replace_url_literal(line, url)
      line.sub(/url\s+"[^"]+"/, "url \"#{url}\"")
    end
  end
end
