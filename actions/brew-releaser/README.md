# brew-releaser

GitHub Action that creates or updates Homebrew **Cask** and **Formula** files in a tap repository. Downloads release artifacts, computes SHA256 checksums, and opens a pull request — fully automated.

## Features

- **Cask + Formula** — supports both macOS app (`.dmg`) and CLI tool (`.tar.gz`) distribution
- **Auto-create** — generates a new Cask/Formula from scratch on first release; updates in-place on subsequent releases
- **Multi-arch** — arm64-only, x86_64-only, or dual-architecture
- **Multi-platform** — Formula supports macOS + Linux combinations
- **Zero-config tap** — no manual file creation needed in the tap repository
- **Configurable** — works with any tap repo, not just the one hosting this action

## Usage

### Cask (macOS app)

```yaml
- uses: samzong/homebrew-tap/actions/brew-releaser@v1
  with:
    type: cask
    version: "1.0.0"
    app_name: Mote
    dmg_url: "https://github.com/samzong/Mote/releases/download/v1.0.0/Mote-arm64.dmg"
    desc: "macOS background app that rewrites selected text system-wide"
    min_macos: ":sequoia"
    token: ${{ secrets.GH_PAT }}
```

### Cask (dual architecture)

```yaml
- uses: samzong/homebrew-tap/actions/brew-releaser@v1
  with:
    type: cask
    version: "0.2.1"
    app_name: ConfigForge
    dmg_url: "https://github.com/samzong/ConfigForge/releases/download/v0.2.1/ConfigForge-arm64.dmg"
    dmg_x86_url: "https://github.com/samzong/ConfigForge/releases/download/v0.2.1/ConfigForge-x86_64.dmg"
    desc: "SSH and Kubernetes configuration management tool"
    token: ${{ secrets.GH_PAT }}
```

### Formula (CLI tool)

```yaml
- uses: samzong/homebrew-tap/actions/brew-releaser@v1
  with:
    type: formula
    version: "0.8.0"
    app_name: gmc
    formula_urls: |
      {
        "darwin-arm64": "https://github.com/samzong/gmc/releases/download/v0.8.0/gmc_Darwin_arm64.tar.gz",
        "darwin-x86_64": "https://github.com/samzong/gmc/releases/download/v0.8.0/gmc_Darwin_x86_64.tar.gz",
        "linux-arm64": "https://github.com/samzong/gmc/releases/download/v0.8.0/gmc_Linux_arm64.tar.gz",
        "linux-x86_64": "https://github.com/samzong/gmc/releases/download/v0.8.0/gmc_Linux_x86_64.tar.gz"
      }
    desc: "CLI that accelerates Git add and commit"
    license: MIT
    token: ${{ secrets.GH_PAT }}
```

### Full release workflow example

```yaml
name: Release
on:
  push:
    tags: ["v*"]
permissions:
  contents: write
jobs:
  release:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v6
      - id: v
        run: echo "version=${GITHUB_REF#refs/tags/v}" >> "$GITHUB_OUTPUT"
      - run: make dmg
      - uses: softprops/action-gh-release@v2
        with:
          files: .build/*-arm64.dmg
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - uses: samzong/homebrew-tap/actions/brew-releaser@v1
        with:
          type: cask
          version: ${{ steps.v.outputs.version }}
          app_name: Mote
          dmg_url: "https://github.com/${{ github.repository }}/releases/download/v${{ steps.v.outputs.version }}/Mote-arm64.dmg"
          desc: "macOS background app that rewrites selected text system-wide"
          min_macos: ":sequoia"
          token: ${{ secrets.GH_PAT }}
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `type` | **yes** | — | `cask` or `formula` |
| `version` | **yes** | — | Version without `v` prefix |
| `app_name` | **yes** | — | Application or binary name |
| `token` | **yes** | — | GitHub PAT with tap repo write access |
| `tap_repo` | no | `samzong/homebrew-tap` | Target tap in `owner/repo` format |
| `file_path` | no | auto | Path in tap (e.g. `Casks/my-app.rb`) |
| `desc` | no | `{app_name}` | Short description |
| `homepage` | no | auto | Homepage URL |
| `dmg_url` | cask | — | arm64 DMG download URL |
| `dmg_x86_url` | no | — | x86_64 DMG download URL |
| `min_macos` | no | `:sonoma` | Minimum macOS version symbol |
| `formula_urls` | formula | — | JSON object of platform-arch → URL |
| `binary_name` | no | `{app_name}` | Binary name for `bin.install` |
| `license` | no | — | SPDX license identifier |

## Outputs

| Output | Description |
|--------|-------------|
| `pr_url` | URL of the created pull request |
| `file_path` | Path to the Cask/Formula file in the tap |

## How it works

```
1. Validate inputs, resolve file path
2. Download release artifacts (DMG or tar.gz)
3. Compute SHA256 checksums (cross-platform: sha256sum / shasum)
4. Clone tap repo, create branch
5. If file exists → sed update version + SHA256
   If file missing → generate from template
6. Commit, push, open PR
```

## Conventions

### DMG naming (Cask)

```
{APP_NAME}-arm64.dmg        # arm64
{APP_NAME}-x86_64.dmg       # Intel (optional)
```

Version goes in the URL path (`/v1.0.0/`), not in the filename.

### tar.gz naming (Formula)

```
{binary}_Darwin_arm64.tar.gz
{binary}_Darwin_x86_64.tar.gz
{binary}_Linux_arm64.tar.gz
{binary}_Linux_x86_64.tar.gz
```

## Requirements

- `jq` must be available on the runner (pre-installed on GitHub-hosted runners)
- `curl`, `git`, `sed` (standard on all runners)
- The `token` must have `contents:write` and `pull_requests:write` on the tap repo
