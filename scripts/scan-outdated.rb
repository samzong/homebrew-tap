#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "optparse"
require_relative "lib/homebrew_tap/package_tools"

options = {
  manifest: "packages/manifest.yml",
  root: HomebrewTap.repo_root,
  include_report_only: false,
  report_file: "outdated-packages.md"
}

OptionParser.new do |parser|
  parser.banner = "Usage: scripts/scan-outdated.rb [options]"
  parser.on("--manifest PATH", "Manifest path") { |value| options[:manifest] = value }
  parser.on("--include-report-only", "Include packages with auto_bump_on_scan=false in the update matrix") do
    options[:include_report_only] = true
  end
  parser.on("--report-file PATH", "Write markdown report") { |value| options[:report_file] = value }
end.parse!

begin
  root = Pathname.new(options[:root])
  manifest = HomebrewTap::Manifest.new(root.join(options[:manifest]))
  github = HomebrewTap::GitHubClient.new
  rows = []
  updates = []

  manifest.each_package do |name, package|
    path = root.join(package.fetch("path"))
    current = HomebrewTap.current_version(path)
    auto = package.fetch("auto_bump_on_scan", true) != false

    begin
      latest = github.latest_release(package.fetch("source_repo"), allow_prerelease: package["allow_prerelease"] == true)
    rescue HomebrewTap::Error => e
      rows << [name, current, "n/a", "scan error: #{e.message}", auto ? "yes" : "no"]
      next
    end

    if latest.nil?
      rows << [name, current, "n/a", "no published release", auto ? "yes" : "no"]
      next
    end

    latest_version = HomebrewTap.normalize_version(latest.fetch("tag_name"))
    status = latest_version == current ? "current" : "outdated"
    rows << [name, current, latest.fetch("tag_name"), status, auto ? "yes" : "no"]

    next unless status == "outdated"
    next unless auto || options[:include_report_only]

    updates << { package: name, version: latest_version }
  end

  report = +"# Homebrew Tap Outdated Package Scan\n\n"
  report << "| Package | Tap version | Latest release | Status | Auto bump on scan |\n"
  report << "|---|---:|---:|---|---|\n"
  rows.each do |name, current, latest, status, auto|
    report << "| `#{name}` | `#{current}` | `#{latest}` | #{status} | #{auto} |\n"
  end
  report << "\nUpdate matrix candidates: `#{updates.length}`\n"

  File.write(root.join(options[:report_file]), report)
  File.open(ENV["GITHUB_STEP_SUMMARY"], "a") { |file| file.write(report) } if ENV["GITHUB_STEP_SUMMARY"]

  if (output = ENV["GITHUB_OUTPUT"])
    File.open(output, "a") do |file|
      file.puts "updates=#{JSON.generate(updates)}"
      file.puts "count=#{updates.length}"
    end
  end

  puts report
rescue HomebrewTap::Error => e
  warn "error: #{e.message}"
  exit 1
end
