#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "optparse"
require_relative "lib/homebrew_tap/package_tools"

options = {
  manifest: "packages/manifest.yml",
  root: HomebrewTap.repo_root,
  base: ENV["BASE_SHA"],
  head: ENV["HEAD_SHA"] || "HEAD"
}

OptionParser.new do |parser|
  parser.banner = "Usage: scripts/check-auto-merge-eligibility.rb --base SHA --head SHA [options]"
  parser.on("--manifest PATH", "Manifest path") { |value| options[:manifest] = value }
  parser.on("--base SHA", "Base git revision") { |value| options[:base] = value }
  parser.on("--head SHA", "Head git revision") { |value| options[:head] = value }
end.parse!

def git_stdout(root, *args)
  stdout, stderr, status = Open3.capture3("git", *args, chdir: root.to_s)
  return stdout if status.success?

  raise HomebrewTap::Error, "git #{args.join(" ")} failed: #{stderr.strip}"
end

def allowed_package_update_line?(content)
  /^version\s+"[^"]+"$/.match?(content) ||
    /^sha256\s+"[0-9a-fA-F]{64}"$/.match?(content) ||
    /^url\s+"[^"]+"(?:,\s*.*)?$/.match?(content)
end

def version_from_line(content)
  content.match(/^version\s+"([^"]+)"$/)&.[](1)
end

begin
  raise HomebrewTap::Error, "--base is required" unless options[:base]

  root = Pathname.new(options[:root])
  manifest = HomebrewTap::Manifest.new(root.join(options[:manifest]))

  changes = git_stdout(root, "diff", "--name-status", options[:base], options[:head], "--")
            .lines
            .map { |line| line.chomp.split("\t") }
            .reject(&:empty?)

  raise HomebrewTap::Error, "changed file count is #{changes.length}; expected 1" unless changes.length == 1

  status, *paths = changes.first
  changed_path = paths.last
  raise HomebrewTap::Error, "changed file status is #{status}; expected M" unless status == "M"

  package_name, package = manifest.package_for_path(changed_path)
  raise HomebrewTap::Error, "#{changed_path} is not a package file managed by packages/manifest.yml" unless package
  raise HomebrewTap::Error, "#{package_name} is not enabled for automatic package updates" unless package["auto_bump_on_scan"] == true

  patch = git_stdout(root, "diff", options[:base], options[:head], "--", changed_path)
  changed_patch_lines = patch
                        .lines
                        .map(&:chomp)
                        .select { |line| (line.start_with?("+") || line.start_with?("-")) && !line.start_with?("+++") && !line.start_with?("---") }

  disallowed_patch_lines = changed_patch_lines.reject { |line| allowed_package_update_line?(line[1..].strip) }
  if disallowed_patch_lines.any?
    raise HomebrewTap::Error, "package file edits include lines other than version, sha256, or url"
  end

  removed_versions = changed_patch_lines
                     .select { |line| line.start_with?("-") }
                     .map { |line| version_from_line(line[1..].strip) }
                     .compact
  added_versions = changed_patch_lines
                   .select { |line| line.start_with?("+") }
                   .map { |line| version_from_line(line[1..].strip) }
                   .compact

  unless removed_versions.length == 1 && added_versions.length == 1
    raise HomebrewTap::Error, "version change count is -#{removed_versions.length}/+#{added_versions.length}; expected -1/+1"
  end
  raise HomebrewTap::Error, "version did not change: #{added_versions.first}" if removed_versions.first == added_versions.first

  puts "Auto-merge eligible: #{package_name} #{removed_versions.first} -> #{added_versions.first}"
rescue HomebrewTap::Error => e
  warn "error: #{e.message}"
  exit 1
end
