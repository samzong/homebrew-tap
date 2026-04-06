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
| GitHub Notifier | GUI App | A macOS menu bar app for GitHub notifications | v0.5.4 |
| HF Model Downloader | GUI App | GUI tool for downloading Hugging Face models | v0.6.1 |
| LogoWallpaper | GUI App | A wallpaper application for macOS | v0.2.0 |
| MacMusicPlayer | GUI App | Simple and elegant music player | v0.5.0 |
| Prompts | GUI App | System-level prompt management tool | v0.1.9 |
| SaveEye | GUI App | Minimalist eye care reminder app | v1.0.12 |
| gmc | CLI Tool | CLI for that accelerates the efficiency of Git add and commit | v0.8.0 |
| gofs | CLI Tool | Lightweight, fast HTTP file server written in Go | v0.2.4 |
| mdctl | CLI Tool | CLI tool for managing markdown files | v0.1.1 |
| mirrormate | CLI Tool | One-shot mirror injection for Docker builds and compose workflows. | v0.0.7 |
| mm | CLI Tool | CLI for that help you fast to contribution to projects | v0.0.5 |
| ConfigForge | GUI App | Open-source SSH configuration and Kubernetes configuration management tool | v0.2.1 |

## brew-releaser

This tap ships a reusable GitHub Action for automating Homebrew Cask and Formula updates.

```yaml
- uses: samzong/homebrew-tap/actions/brew-releaser@main
  with:
    type: cask          # or formula
    version: "1.0.0"
    app_name: MyApp
    dmg_url: "https://github.com/…/MyApp-arm64.dmg"
    token: ${{ secrets.GH_PAT }}
```

See [actions/brew-releaser/README.md](actions/brew-releaser/README.md) for full documentation.

## Documentation

- `brew help`
- `man brew`
- [Homebrew's documentation](https://docs.brew.sh)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
