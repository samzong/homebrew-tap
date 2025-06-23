# Samzong's Homebrew Tap

<div align="center">
  <img src="https://brew.sh/assets/img/homebrew.svg" alt="homebrew-tap logo" width="100" />
  <br />
  <p>This is a custom Homebrew tap for my personal applications and tools.</p>
</div>

## Usage

```bash
# Add the tap
brew tap samzong/tap

# To install an application:
brew install APP_NAME

# Example:
brew install hf-model-downloader
brew install mdctl
```

## Available Applications

| Application Name    | Type     | Description                                                                 | Latest Version |
| ------------------- | -------- | --------------------------------------------------------------------------- | -------------- |
| ConfigForge         | GUI App  | ConfigForge is an open-source SSH configuration management tool for macOS   | v0.1.0         |
| HF Model Downloader | GUI App  | A cross-platform GUI application for easily downloading Hugging Face models | v0.0.6         |
| Mac Music Player    | GUI App  | A modern music player for macOS                                             | v0.4.0         |
| Prompts             | GUI App  | System-level prompt management tool for macOS                              | v0.1.9         |
| gmc                 | CLI Tool | A CLI tool for managing markdown files                                     | v0.0.4         |
| mdctl               | CLI Tool | A command-line tool for managing markdown files                             | v0.1.1         |

## Documentation

- `brew help`
- `man brew`
- [Homebrew's documentation](https://docs.brew.sh)

### Cask App Unsigned

```ruby
  # other install step
  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Prompts.app"]
  end
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
