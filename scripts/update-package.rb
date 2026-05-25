#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "optparse"
require "tempfile"
require_relative "lib/homebrew_tap/package_tools"

options = {
  manifest: "packages/manifest.yml",
  root: HomebrewTap.repo_root,
  dry_run: false,
  summary_file: ".update-package-summary.md"
}

OptionParser.new do |parser|
  parser.banner = "Usage: scripts/update-package.rb --package NAME [--version VERSION|latest] [options]"
  parser.on("--package NAME", "Package name from packages/manifest.yml") { |value| options[:package] = value }
  parser.on("--version VERSION", "Release version, with or without v prefix; defaults to latest") { |value| options[:version] = value }
  parser.on("--manifest PATH", "Manifest path") { |value| options[:manifest] = value }
  parser.on("--summary-file PATH", "Write PR summary markdown") { |value| options[:summary_file] = value }
  parser.on("--dry-run", "Print the planned update without writing files") { options[:dry_run] = true }
end.parse!

tmpdir = nil

begin
  raise HomebrewTap::Error, "--package is required" unless options[:package]

  root = Pathname.new(options[:root])
  manifest = HomebrewTap::Manifest.new(root.join(options[:manifest]))
  package = manifest.package(options[:package])
  package_path = root.join(package.fetch("path"))

  raise HomebrewTap::Error, "package file does not exist: #{package_path}; create it manually first" unless package_path.file?

  github = HomebrewTap::GitHubClient.new
  requested_version = options[:version].to_s.strip
  if requested_version.empty? || requested_version == "latest"
    release = github.latest_release(package.fetch("source_repo"), allow_prerelease: package["allow_prerelease"] == true)
    raise HomebrewTap::Error, "no published release found for #{package.fetch("source_repo")}" unless release

    tag = release.fetch("tag_name")
    version = HomebrewTap.normalize_version(tag)
  else
    version = HomebrewTap.normalize_version(requested_version)
    tag = HomebrewTap.tag_for(package, version)
    release = github.release_by_tag(package.fetch("source_repo"), tag)
    raise HomebrewTap::Error, "release is draft: #{package.fetch("source_repo")}@#{tag}" if release.fetch("draft")
    if release.fetch("prerelease") && package["allow_prerelease"] != true
      raise HomebrewTap::Error, "release is prerelease and allow_prerelease is not enabled: #{package.fetch("source_repo")}@#{tag}"
    end
  end

  assets_by_name = release.fetch("assets").to_h { |asset| [asset.fetch("name"), asset] }
  tmpdir = Dir.mktmpdir("homebrew-tap-update-")
  computed_assets = []

  package.fetch("assets").each do |asset_key, asset_config|
    filename = HomebrewTap.expand_template(asset_config.fetch("filename"), version: version, tag: tag)
    release_asset = assets_by_name[filename]
    unless release_asset
      available = assets_by_name.keys.sort.join(", ")
      raise HomebrewTap::Error, "release asset not found for #{options[:package]}.#{asset_key}: #{filename}. Available: #{available}"
    end

    destination = File.join(tmpdir, filename)
    github.download(release_asset.fetch("browser_download_url"), destination)
    raise HomebrewTap::Error, "downloaded asset is empty: #{filename}" if File.zero?(destination)

    sha256 = HomebrewTap.sha256_file(destination)
    computed_assets << {
      key: asset_key,
      filename: filename,
      url: release_asset.fetch("browser_download_url"),
      sha256: sha256,
      config: asset_config.merge("filename" => filename)
    }
  end

  original = File.read(package_path)
  editor = HomebrewTap::PackageEditor.new(package_path)
  old_version = HomebrewTap.current_version(package_path)
  editor.replace_version!(version)
  computed_assets.each do |asset|
    editor.update_asset!(asset.fetch(:config), sha256: asset.fetch(:sha256), url: asset.fetch(:url))
  end
  updated = editor.content

  summary = +"## Summary\n"
  summary << "- update `#{package.fetch("path")}` from `#{old_version}` to `#{version}`\n"
  summary << "- source release: `#{package.fetch("source_repo")}@#{tag}`\n"
  summary << "- refresh SHA256 checksums for configured release assets\n\n"
  summary << "## Assets\n"
  computed_assets.each do |asset|
    summary << "- `#{asset.fetch(:filename)}`: `#{asset.fetch(:sha256)}`\n"
  end
  summary << "\n## Verification\n"
  summary << "- verified GitHub release exists and is not draft\n"
  summary << "- downloaded configured release assets and computed SHA256 values\n"
  summary << "- updater changed only version/SHA256 and static URLs when required by the existing file format\n"

  File.write(root.join(options[:summary_file]), summary)

  if original == updated
    puts "#{options[:package]} is already current at #{version}"
  elsif options[:dry_run]
    Tempfile.create(["homebrew-tap-update", ".rb"]) do |tmp|
      tmp.write(updated)
      tmp.flush
      system("ruby", "-c", tmp.path, exception: true)
      system("diff", "-u", package_path.to_s, tmp.path, exception: false)
    end
  else
    File.write(package_path, updated)
    system("ruby", "-c", package_path.to_s, exception: true)
    puts "Updated #{package.fetch("path")} to #{version}"
  end

  if (output = ENV["GITHUB_OUTPUT"])
    branch = "update/#{options[:package]}-#{version}"
    title = "chore: update #{options[:package]} to #{version}"
    File.open(output, "a") do |file|
      file.puts "package=#{options[:package]}"
      file.puts "version=#{version}"
      file.puts "branch=#{branch}"
      file.puts "title=#{title}"
      file.puts "file_path=#{package.fetch("path")}"
      file.puts "summary_file=#{options[:summary_file]}"
    end
  end
rescue HomebrewTap::Error => e
  warn "error: #{e.message}"
  exit 1
ensure
  FileUtils.rm_rf(tmpdir) if tmpdir
end
