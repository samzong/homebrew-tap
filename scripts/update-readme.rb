#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "open3"
require "pathname"
require_relative "lib/homebrew_tap/package_tools"

options = { dry_run: false }

OptionParser.new do |parser|
  parser.banner = "Usage: scripts/update-readme.rb [--dry-run]"
  parser.on("--dry-run", "Print the generated table without writing README.md") { options[:dry_run] = true }
end.parse!

class ReadmeUpdater
  TABLE_HEADER = /\| Application Name\s+\| Type\s+\| Description\s+\| Latest Version\s+\|/.freeze

  def initialize(root:, dry_run:)
    @root = Pathname.new(root)
    @dry_run = dry_run
    @readme_path = @root.join("README.md")
  end

  def run
    puts "Starting Homebrew Tap README updater"
    puts "Dry run: README.md will not be modified" if @dry_run

    check_version_consistency
    update_readme
    puts "Update completed successfully"
  end

  private

  def update_readme
    raise "README.md file not found" unless @readme_path.file?

    apps = all_apps
    puts "Found #{apps.length} applications:"
    apps.each { |app| puts "  - #{app.fetch(:name)} (#{app.fetch(:type)}): #{display_version(app.fetch(:version))}" }

    content = @readme_path.read
    start_match = content.match(TABLE_HEADER)
    raise "Could not find application table in README.md" unless start_match

    header_end = content.index("\n", start_match.begin(0))
    separator_end = content.index("\n", header_end + 1)
    raise "Could not find application table separator in README.md" unless separator_end

    after_table = content[(separator_end + 1)..]
    next_section = after_table&.match(/\n## /)
    table_end = next_section ? separator_end + 1 + next_section.begin(0) : content.length

    new_rows = table_rows(apps)
    new_content = content[0..separator_end] + new_rows + "\n" + content[table_end..]

    if @dry_run
      puts "\n=== DRY RUN MODE ==="
      puts "New table content would be:"
      puts new_rows
      puts "=== END DRY RUN ==="
    else
      @readme_path.write(new_content)
      puts "README.md updated successfully"
    end
  end

  def all_apps
    casks = @root.join("Casks").glob("*.rb").map { |path| parse_cask(path) }.compact
    formulae = @root.join("Formula").glob("*.rb").map { |path| parse_formula(path) }.compact

    (casks + formulae).sort_by { |app| [-app.fetch(:last_modified), app.fetch(:name).downcase] }
  end

  def parse_cask(path)
    content = path.read
    file_name = path.basename(".rb").to_s
    {
      file_name: file_name,
      name: match(content, /name\s+["']([^"']+)["']/) || format_app_name(file_name),
      desc: match(content, /desc\s+["']([^"']+)["']/) || "No description available",
      version: match(content, /version\s+["']([^"']+)["']/) || "Unknown",
      type: "GUI App",
      last_modified: git_modified_time(path)
    }
  rescue StandardError => e
    warn "Error parsing cask file #{path}: #{e.message}"
    nil
  end

  def parse_formula(path)
    content = path.read
    file_name = path.basename(".rb").to_s
    class_name = match(content, /class\s+(\w+)\s+<\s+Formula/)
    {
      file_name: file_name,
      name: class_name ? class_name.downcase : file_name,
      desc: match(content, /desc\s+["']([^"']+)["']/) || "No description available",
      version: match(content, /version\s+["']([^"']+)["']/) || "Unknown",
      type: "CLI Tool",
      last_modified: git_modified_time(path)
    }
  rescue StandardError => e
    warn "Error parsing formula file #{path}: #{e.message}"
    nil
  end

  def check_version_consistency
    puts "\nChecking for version inconsistencies..."

    content = @readme_path.read
    inconsistent = false
    all_apps.each do |app|
      readme_version = extract_version_from_readme(content, app.fetch(:name))
      actual_version = display_version(app.fetch(:version))
      next unless readme_version && readme_version != actual_version

      puts "  #{app.fetch(:name)}: README shows #{readme_version}, actual is #{actual_version}"
      inconsistent = true
    end

    puts "All versions are consistent" unless inconsistent
  end

  def table_rows(apps)
    apps.map do |app|
      "| #{app.fetch(:name)} | #{app.fetch(:type)} | #{app.fetch(:desc)} | #{display_version(app.fetch(:version))} |"
    end.join("\n")
  end

  def extract_version_from_readme(content, app_name)
    escaped = Regexp.escape(app_name)
    match(content, /\|\s*#{escaped}\s*\|[^|]*\|[^|]*\|\s*([^|\s]+)\s*\|/i)
  end

  def display_version(version)
    version.to_s.start_with?("v") ? version.to_s : "v#{version}"
  end

  def format_app_name(file_name)
    file_name.split("-").map(&:capitalize).join(" ")
  end

  def git_modified_time(path)
    relative = path.relative_path_from(@root).to_s
    stdout, status = Open3.capture2("git", "log", "-1", "--format=%ct", "--", relative, chdir: @root.to_s)
    return stdout.to_i if status.success? && !stdout.strip.empty?

    path.mtime.to_i
  end

  def match(content, regex)
    content.match(regex)&.captures&.first
  end
end

begin
  ReadmeUpdater.new(root: HomebrewTap.repo_root, dry_run: options.fetch(:dry_run)).run
rescue StandardError => e
  warn "Update failed: #{e.message}"
  exit 1
end
