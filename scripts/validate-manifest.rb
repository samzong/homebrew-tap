#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require_relative "lib/homebrew_tap/package_tools"

options = {
  manifest: "packages/manifest.yml",
  root: HomebrewTap.repo_root
}

OptionParser.new do |parser|
  parser.banner = "Usage: scripts/validate-manifest.rb [--manifest PATH]"
  parser.on("--manifest PATH", "Manifest path") { |value| options[:manifest] = value }
end.parse!

begin
  root = Pathname.new(options[:root])
  manifest = HomebrewTap::Manifest.new(root.join(options[:manifest]))
  manifest.validate!(root: root)
  puts "Manifest OK: #{manifest.packages.length} packages"
rescue HomebrewTap::Error => e
  warn "error: #{e.message}"
  exit 1
end
