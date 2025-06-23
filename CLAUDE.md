# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Homebrew Tap repository** that distributes macOS applications and cross-platform command-line tools developed by samzong. A Homebrew Tap is a third-party repository that extends Homebrew's package management capabilities.

## Repository Structure

```
homebrew-tap/
├── Casks/           # GUI applications (.app bundles distributed as .dmg files)
├── Formula/         # Command-line tools (distributed as .tar.gz archives)
├── DEVELOPMENT.md   # Comprehensive development and maintenance guide
└── README.md        # User-facing documentation
```

## Application Categories

### GUI Applications (Casks)
- **ConfigForge**: SSH configuration management tool
- **HF Model Downloader**: Hugging Face model downloader
- **Mac Music Player**: Modern music player with yt-dlp/ffmpeg dependencies
- **Prompts**: Prompt management tool

### Command-Line Tools (Formula)
- **mdctl**: Markdown file management tool (supports macOS and Linux)
- **gmc**: Markdown management tool (supports macOS and Linux)

## Architecture Patterns

### Multi-Architecture Support
All applications support both ARM64 and x86_64 architectures using conditional blocks:

```ruby
if Hardware::CPU.arm?
  url "https://example.com/app-arm64.dmg"
  sha256 "arm64_hash"
else  
  url "https://example.com/app-x86_64.dmg" 
  sha256 "x86_64_hash"
end
```

### Cross-Platform Formula
Command-line tools support both macOS and Linux:

```ruby
on_macos do
  # macOS-specific downloads
end

on_linux do
  # Linux-specific downloads  
end
```

### Security Handling
GUI applications include postflight scripts to clear macOS extended attributes:

```ruby
postflight do
  system_command "xattr", args: ["-cr", "#{appdir}/AppName.app"]
end
```

## Common Development Tasks

### Manual Version Updates
1. **Create update branch**: `git checkout -b update-APP_NAME-VERSION`
2. **Update .rb file**: Modify `version`, `url`, and `sha256` fields
3. **Calculate SHA256**: `curl -sL "DOWNLOAD_URL" | shasum -a 256`
4. **Commit**: `git commit -m "chore: update APP_NAME to vVERSION"`
5. **Push and create PR**

### Automated Updates
Use the update script from DEVELOPMENT.md:
```bash
./update-app.sh app-name 1.0.0 https://example.com/download.dmg
```

### Version Verification
Test installations locally:
```bash
brew tap samzong/tap
brew install --verbose --debug APP_NAME
```

## File Patterns

### Cask Structure
- Version string interpolation: `v#{version}`
- Architecture-specific URLs and hashes
- App bundle installation: `app "AppName.app"`
- Cleanup configurations: `zap trash: [...]`
- System dependencies: `depends_on formula: ["dependency"]`

### Formula Structure  
- Cross-platform conditional blocks
- Binary installation: `bin.install "binary_name"`
- Version test: `system "#{bin}/binary", "--version"`

## Release Integration

The repository integrates with GitHub Actions for automated updates when new versions are released in source repositories. See DEVELOPMENT.md for complete GitHub Actions workflow configuration.

## Testing Commands

```bash
# Test formula syntax
brew audit --strict Formula/APP_NAME.rb

# Test cask syntax  
brew audit --strict Casks/APP_NAME.rb

# Test installation
brew install --verbose --debug APP_NAME
```

## Key Conventions

- Commit messages: `chore: update APP_NAME to vVERSION`
- Branch names: `update-APP_NAME-VERSION`
- All SHA256 hashes must be verified before updating
- GUI apps require xattr clearing for security
- Dependencies should be declared explicitly