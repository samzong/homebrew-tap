# Samzong's Homebrew Tap

[English](README.md) | [中文](README_zh.md)

This is a custom Homebrew tap for my personal applications and tools.

## Installation

```bash
brew tap samzong/tap
```

## Available Applications

| Application Name | Type | Description | Latest Version | Last Updated |
|-----------------|------|-------------|----------------|--------------|
| HF Model Downloader | GUI App | A cross-platform GUI application for easily downloading Hugging Face models | v0.0.4 | 2025-03-04 |
| Mac Music Player | GUI App | A modern music player for macOS | v0.1.7 | 2025-02-21 |
| mdctl | CLI Tool | A command-line tool for managing markdown files | v0.0.10 | 2025-02-25 |

## Usage

To install an application:

```bash
# For GUI applications
brew install --cask samzong/tap/APP_NAME

# For CLI tools
brew install samzong/tap/TOOL_NAME

# Examples:
brew install --cask samzong/tap/hf-model-downloader
brew install samzong/tap/mdctl
```

## Documentation

- `brew help`
- `man brew`
- [Homebrew's documentation](https://docs.brew.sh)
