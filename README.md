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
| HF Model Downloader | GUI App | A GUI tool for downloading Hugging Face models | v0.6.1 |
| gofs | CLI Tool | A lightweight, fast HTTP file server written in Go | v0.2.4 |
| gmc | CLI Tool | CLI for that accelerates the efficiency of Git add and commit | v0.0.8 |
| mm | CLI Tool | CLI for that help you fast to contribution to projects. | v0.0.5 |
| SaveEye | GUI App | minimalist eye care reminder app | v1.0.12 |
| MacMusicPlayer | GUI App | Simple and elegant music player | v0.4.2 |
| ConfigForge | GUI App | Open-source SSH configuration and Kubernetes configuration management tool | v0.1.0 |
| mdctl | CLI Tool | CLI tool for managing markdown files | v0.1.1 |
| Prompts | GUI App | System-level prompt management tool | v0.1.9 |

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
