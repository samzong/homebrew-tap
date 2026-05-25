# Project Integration Guide

This tap uses manifest-driven package updates.

## Package ownership model

- Source projects build and publish GitHub Release assets.
- `samzong/homebrew-tap` owns Formula/Cask version and SHA256 updates.
- The first `Formula/*.rb` or `Casks/*.rb` file is still created manually.
- Automation only updates existing package files.

## Default trigger: scheduled scan

No source project changes are required for the default path.

Every 30 minutes, `Scan Outdated Packages` reads `packages/manifest.yml`, compares each tap version to the latest non-draft GitHub release, and opens/updates a package PR when a package is stale and `auto_bump_on_scan` is enabled.

## Optional fast path: release notification

Projects that need immediate Homebrew updates can notify the tap after release assets are uploaded.

Add this step at the end of the source repo release workflow:

```yaml
- name: Notify Homebrew tap
  if: success()
  env:
    GH_TOKEN: ${{ secrets.HOMEBREW_TAP_PAT }}
  run: |
    VERSION="${GITHUB_REF_NAME#v}"
    gh api repos/samzong/homebrew-tap/dispatches \
      --method POST \
      --field event_type=homebrew-package-release \
      --field client_payload[package]=PACKAGE_NAME \
      --field client_payload[version]="${VERSION}"
```

Replace `PACKAGE_NAME` with the package key from `packages/manifest.yml`.

The source project token only needs permission to trigger repository dispatch on `samzong/homebrew-tap`. It does not need to clone, push, or edit the tap.

## Manual update

Maintainers can run an update directly:

```bash
gh workflow run update-package.yml \
  --repo samzong/homebrew-tap \
  --field package=recall

# Or pin a specific version:
gh workflow run update-package.yml \
  --repo samzong/homebrew-tap \
  --field package=recall \
  --field version=0.2.1
```

Local dry-run:

```bash
ruby scripts/update-package.rb \
  --package recall \
  --dry-run

# Or pin a specific version:
ruby scripts/update-package.rb \
  --package recall \
  --version 0.2.1 \
  --dry-run
```

## Adding a new package

1. Publish a GitHub release with stable asset names.
2. Manually add the first `Formula/*.rb` or `Casks/*.rb` file.
3. Add a package entry to `packages/manifest.yml`.
4. Run:

```bash
ruby scripts/validate-manifest.rb
ruby scripts/update-package.rb --package PACKAGE_NAME --dry-run
```

5. Trigger `Update Package` once manually.
6. Optionally add the release notification step in the source project.
