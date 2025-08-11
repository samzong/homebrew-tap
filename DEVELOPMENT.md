# Development Guide

## Version Update Workflow

This document describes the standard process for updating Cask or Formula files.

### 1. Fork the Repository

1. Visit https://github.com/samzong/homebrew-tap
2. Click the "Fork" button in the top right to create your fork

### 2. Clone the Repository

```bash
git clone https://github.com/samzong/homebrew-tap.git
cd homebrew-tap
```

### 3. Create an Update Branch

```bash
git checkout -b update-APP_NAME-VERSION
# Example: git checkout -b update-hf-model-downloader-0.0.4
```

### 4. Update File Contents

#### Cask apps (GUI applications)

Update the following fields in `Casks/APP_NAME.rb`:

```ruby
version "NEW_VERSION"
sha256 "NEW_SHA256"
url "NEW_DOWNLOAD_URL"
```

Calculate the SHA256 checksum:

```bash
# Calculate from a local file
shasum -a 256 APP_NAME.dmg

# Calculate from a remote file
curl -sL "DOWNLOAD_URL" | shasum -a 256
```

#### Formula (CLI tools)

Update the following fields in `Formula/APP_NAME.rb`:

```ruby
version "NEW_VERSION"
sha256 "NEW_SHA256"
url "NEW_DOWNLOAD_URL"
```

### 5. Commit the Changes

```bash
git add .
git commit -m "chore: update APP_NAME to vNEW_VERSION"
git push origin update-APP_NAME-VERSION
```

### 6. Create a Pull Request

1. Go to your fork on GitHub
2. Click "Compare & pull request"
3. Fill in the PR using the following format:

Title format:

```bash
chore: update APP_NAME to vNEW_VERSION
```

Description template:

```markdown
Update details:

- Version: vNEW_VERSION
- Download URL: NEW_DOWNLOAD_URL
- SHA256: NEW_SHA256

Changes:

- [ ] Version updated
- [ ] Download URL updated
- [ ] SHA256 updated
```

## Automation Tools

### Local Automation Script

A shell script to quickly generate an update PR:

```bash
#!/bin/bash

# Usage: ./update-app.sh app-name 1.0.0 https://example.com/download/app-1.0.0.dmg
APP_NAME=$1
VERSION=$2
DOWNLOAD_URL=$3

# Validate arguments
if [ -z "$APP_NAME" ] || [ -z "$VERSION" ] || [ -z "$DOWNLOAD_URL" ]; then
    echo "Usage: ./update-app.sh app-name version download-url"
    exit 1
fi

# Calculate SHA256
SHA256=$(curl -sL "$DOWNLOAD_URL" | shasum -a 256 | cut -d ' ' -f 1)

# Create update branch
git checkout -b update-$APP_NAME-$VERSION

# Locate target file
if [ -f "Casks/$APP_NAME.rb" ]; then
    FILE="Casks/$APP_NAME.rb"
elif [ -f "Formula/$APP_NAME.rb" ]; then
    FILE="Formula/$APP_NAME.rb"
else
    echo "Error: Cannot find $APP_NAME.rb"
    exit 1
fi

# Update file contents
sed -i '' "s/version \".*\"/version \"$VERSION\"/" "$FILE"
sed -i '' "s|url \".*\"|url \"$DOWNLOAD_URL\"|" "$FILE"
sed -i '' "s/sha256 \".*\"/sha256 \"$SHA256\"/" "$FILE"

# Commit changes
git add "$FILE"
git commit -m "chore: update $APP_NAME to v$VERSION"
git push origin update-$APP_NAME-$VERSION

echo "Done! PR URL: https://github.com/samzong/homebrew-tap/compare/main...$(git config user.name):update-$APP_NAME-$VERSION"
```

Usage:

```bash
chmod +x update-app.sh
./update-app.sh hf-model-downloader 0.0.4 https://github.com/samzong/hf-downloader/releases/download/v0.0.4/app.dmg
```

### GitHub Action Auto-Update

Use GitHub Actions to automatically update the Homebrew Tap when you publish a release.

#### 1. Token Setup

1. Create a Personal Access Token (PAT) with `repo` permissions
2. In your source repository, go to Settings -> Secrets and add the token as `HOMEBREW_TAP_TOKEN`

#### 2. Workflow Configuration

In your source repository, create `.github/workflows/update-homebrew.yml`:

```yaml
name: Update Homebrew Tap

# Trigger: when a new release is published
on:
  release:
    types: [published]

jobs:
  update-tap:
    runs-on: ubuntu-latest
    steps:
      # Check out the homebrew-tap repository
      - uses: actions/checkout@v4
        with:
          repository: samzong/homebrew-tap
          token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          fetch-depth: 0 # full history for branch creation

      # Git configuration
      - name: Setup Git
        run: |
          git config user.name "GitHub Action"
          git config user.email "action@github.com"

      # Get release information
      - name: Get release info
        id: release
        run: |
          # Extract version (remove 'v' prefix)
          VERSION="${{ github.event.release.tag_name }}"
          VERSION="${VERSION#v}"
          echo "version=$VERSION" >> $GITHUB_OUTPUT

          # Get download URL (example: .dmg asset)
          DOWNLOAD_URL=$(echo '${{ toJson(github.event.release.assets) }}' | jq -r '.[] | select(.name | endswith(".dmg")) | .browser_download_url')
          echo "download_url=$DOWNLOAD_URL" >> $GITHUB_OUTPUT

          # Calculate SHA256
          curl -sL "$DOWNLOAD_URL" | shasum -a 256 | cut -d ' ' -f 1 > sha256.txt
          echo "sha256=$(cat sha256.txt)" >> $GITHUB_OUTPUT

      # Create update branch
      - name: Create branch
        run: |
          APP_NAME="${{ github.event.repository.name }}"
          git checkout -b update-$APP_NAME-${{ steps.release.outputs.version }}

      # Update the file
      - name: Update file
        run: |
          APP_NAME="${{ github.event.repository.name }}"

          # Locate target file
          if [ -f "Casks/$APP_NAME.rb" ]; then
              FILE="Casks/$APP_NAME.rb"
          elif [ -f "Formula/$APP_NAME.rb" ]; then
              FILE="Formula/$APP_NAME.rb"
          else
              echo "Error: Cannot find $APP_NAME.rb"
              exit 1
          fi

          # Update contents
          sed -i "s/version \".*\"/version \"${{ steps.release.outputs.version }}\"/" "$FILE"
          sed -i "s|url \".*\"|url \"${{ steps.release.outputs.download_url }}\"|" "$FILE"
          sed -i "s/sha256 \".*\"/sha256 \"${{ steps.release.outputs.sha256 }}\"/" "$FILE"

      # Create Pull Request
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          commit-message: "chore: update ${{ github.event.repository.name }} to v${{ steps.release.outputs.version }}"
          title: "chore: update ${{ github.event.repository.name }} to v${{ steps.release.outputs.version }}"
          body: |
            Update details:
            - Version: v${{ steps.release.outputs.version }}
            - Download URL: ${{ steps.release.outputs.download_url }}
            - SHA256: ${{ steps.release.outputs.sha256 }}

            Changes:
            - [x] Version updated
            - [x] Download URL updated
            - [x] SHA256 updated

            Created automatically by GitHub Action
          branch: update-${{ github.event.repository.name }}-${{ steps.release.outputs.version }}
          base: main
          delete-branch: true
```

#### 3. Notes

1. Workflow file location: `.github/workflows/update-homebrew.yml`
2. Trigger: automatically runs when a new release is published
3. Automation flow:
   - Retrieve release version
   - Calculate asset SHA256
   - Create an update branch
   - Submit a PR

#### Caveats

- The PAT must have sufficient repository permissions
- Adjust the download URL selection logic based on your release asset format (dmg/zip/etc.)
- You can customize the PR template as needed
