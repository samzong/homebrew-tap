#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "open3"
require_relative "lib/homebrew_tap/package_tools"

options = {
  manifest: "packages/manifest.yml",
  root: HomebrewTap.repo_root,
  base: ENV["BASE_SHA"],
  head: ENV["HEAD_SHA"] || "HEAD"
}

OptionParser.new do |parser|
  parser.banner = "Usage: scripts/review-package-pr.rb --base SHA --head SHA [options]"
  parser.on("--manifest PATH", "Manifest path") { |value| options[:manifest] = value }
  parser.on("--base SHA", "Base git revision") { |value| options[:base] = value }
  parser.on("--head SHA", "Head git revision") { |value| options[:head] = value }
end.parse!

begin
  raise HomebrewTap::Error, "--base is required" unless options[:base]

  root = Pathname.new(options[:root])
  manifest = HomebrewTap::Manifest.new(root.join(options[:manifest]))

  diff_cmd = ["git", "diff", "--name-only", "--diff-filter=ACMR", options[:base], options[:head], "--", "Formula/**", "Casks/**"]
  stdout, status = Open3.capture2(*diff_cmd, chdir: root.to_s)
  raise HomebrewTap::Error, "failed to list changed package files" unless status.success?

  changed = stdout.lines.map(&:strip).reject(&:empty?)
  if changed.empty?
    puts "No Formula/Cask changes to review."
    exit 0
  end

  github = HomebrewTap::GitHubClient.new
  failures = []

  changed.each do |relative_path|
    path = root.join(relative_path)
    puts "Reviewing #{relative_path}"

    system("ruby", "-c", path.to_s, exception: true)

    package_name, package = manifest.package_for_path(relative_path)
    unless package
      puts "  #{relative_path} is not in manifest; ran syntax check only."
      next
    end

    version = HomebrewTap.current_version(path)
    tag = HomebrewTap.tag_for(package, version)
    release = github.release_by_tag(package.fetch("source_repo"), tag)
    if release.fetch("draft")
      failures << "#{package_name}: release is draft: #{tag}"
      next
    end
    if release.fetch("prerelease") && package["allow_prerelease"] != true
      failures << "#{package_name}: release is prerelease but allow_prerelease is not enabled: #{tag}"
      next
    end

    assets_by_name = release.fetch("assets").to_h { |asset| [asset.fetch("name"), asset] }
    editor = HomebrewTap::PackageEditor.new(path)

    package.fetch("assets").each do |asset_key, asset_config|
      filename = HomebrewTap.expand_template(asset_config.fetch("filename"), version: version, tag: tag)
      release_asset = assets_by_name[filename]
      unless release_asset
        failures << "#{package_name}.#{asset_key}: release asset missing: #{filename}"
        next
      end

      Tempfile.create(["homebrew-tap-review", File.extname(filename)]) do |file|
        github.download(release_asset.fetch("browser_download_url"), file.path)
        actual = HomebrewTap.sha256_file(file.path)
        declared = editor.extract_sha(asset_config.merge("filename" => filename))
        if actual == declared
          puts "  ok #{filename} #{actual}"
        else
          failures << "#{package_name}.#{asset_key}: SHA mismatch for #{filename}; declared #{declared}, actual #{actual}"
        end
      end
    end
  end

  if failures.any?
    warn "Package PR review failed:"
    failures.each { |failure| warn "- #{failure}" }
    exit 1
  end

  puts "Package PR review passed for #{changed.length} file(s)."
rescue HomebrewTap::Error => e
  warn "error: #{e.message}"
  exit 1
end
