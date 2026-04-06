#!/usr/bin/env bash
set -euo pipefail

# --- Helpers ---

hash_file() {
  if command -v sha256sum &>/dev/null; then
    sha256sum "$1" | cut -d ' ' -f 1
  else
    shasum -a 256 "$1" | cut -d ' ' -f 1
  fi
}

download() {
  local url="$1" dest="$2"
  echo "  Downloading: $url"
  curl -fSL --retry 3 --retry-delay 5 -o "$dest" "$url"
}

die() { echo "::error::$1"; exit 1; }

# --- Resolve inputs ---

TYPE="$INPUT_TYPE"
VERSION="$INPUT_VERSION"
APP_NAME="$INPUT_APP_NAME"
TOKEN="$INPUT_TOKEN"
TAP_REPO="$INPUT_TAP_REPO"
APP_LOWER="${APP_NAME,,}"
TAP_OWNER="${TAP_REPO%%/*}"
HOMEPAGE="${INPUT_HOMEPAGE:-https://github.com/${TAP_OWNER}/${APP_NAME}}"
DESC="${INPUT_DESC:-${APP_NAME}}"
BIN="${INPUT_BINARY_NAME:-${APP_LOWER}}"
BUNDLE_ID="com.${TAP_OWNER}.${APP_LOWER}"
WORKDIR=$(mktemp -d /tmp/brew-releaser-XXXXXX)

[[ "$TYPE" == "cask" || "$TYPE" == "formula" ]] || die "type must be 'cask' or 'formula', got '$TYPE'"
[[ "$TYPE" == "cask" && -z "$INPUT_DMG_URL" ]] && die "dmg_url is required for type=cask"
[[ "$TYPE" == "formula" && -z "$INPUT_FORMULA_URLS" ]] && die "formula_urls is required for type=formula"

if [ -n "$INPUT_FILE_PATH" ]; then
  FILE_PATH="$INPUT_FILE_PATH"
elif [ "$TYPE" = "cask" ]; then
  FILE_PATH="Casks/${APP_LOWER}.rb"
else
  FILE_PATH="Formula/${APP_LOWER}.rb"
fi

echo "file_path=$FILE_PATH" >> "$GITHUB_OUTPUT"

# --- Download artifacts ---

echo "::group::Download artifacts"
declare -A SHAS

if [ "$TYPE" = "cask" ]; then
  download "$INPUT_DMG_URL" "$WORKDIR/arm64.dmg"
  SHAS[arm64]=$(hash_file "$WORKDIR/arm64.dmg")
  echo "  arm64 SHA256: ${SHAS[arm64]}"

  if [ -n "$INPUT_DMG_X86_URL" ]; then
    download "$INPUT_DMG_X86_URL" "$WORKDIR/x86_64.dmg"
    SHAS[x86_64]=$(hash_file "$WORKDIR/x86_64.dmg")
    echo "  x86_64 SHA256: ${SHAS[x86_64]}"
  fi
else
  for key in $(echo "$INPUT_FORMULA_URLS" | jq -r 'keys[]'); do
    safe=$(echo "$key" | tr '-' '_')
    url=$(echo "$INPUT_FORMULA_URLS" | jq -r --arg k "$key" '.[$k]')
    download "$url" "$WORKDIR/${safe}.tar.gz"
    SHAS[$safe]=$(hash_file "$WORKDIR/${safe}.tar.gz")
    echo "  $key SHA256: ${SHAS[$safe]}"
  done
fi
echo "::endgroup::"

# --- Clone tap ---

echo "::group::Clone tap"
git clone --depth 1 "https://x-access-token:${TOKEN}@github.com/${TAP_REPO}.git" tap
cd tap
BRANCH="brew-releaser/${APP_LOWER}-${VERSION}"
git checkout -b "$BRANCH"
echo "::endgroup::"

# --- Create or update file ---

if [ -f "$FILE_PATH" ]; then
  echo "::group::Update existing $TYPE"

  sed -i "s/version \"[^\"]*\"/version \"${VERSION}\"/" "$FILE_PATH"

  if [ "$TYPE" = "cask" ]; then
    if grep -q "on_arm" "$FILE_PATH"; then
      sed -i "/on_arm/,/end/{s/sha256 \"[^\"]*\"/sha256 \"${SHAS[arm64]}\"/;}" "$FILE_PATH"
      if [ -n "${SHAS[x86_64]:-}" ]; then
        sed -i "/on_intel/,/end/{s/sha256 \"[^\"]*\"/sha256 \"${SHAS[x86_64]}\"/;}" "$FILE_PATH"
      fi
    else
      sed -i "s/sha256 \"[^\"]*\"/sha256 \"${SHAS[arm64]}\"/" "$FILE_PATH"
    fi
  else
    update_formula_sha() {
      local platform="$1" arch="$2"
      local safe="${platform}_${arch}"
      local sha="${SHAS[$safe]:-}"
      [ -z "$sha" ] && return
      local os_block
      [ "$platform" = "darwin" ] && os_block="on_macos" || os_block="on_linux"
      local cpu_check
      [ "$arch" = "arm64" ] && cpu_check="arm?" || cpu_check="intel?"

      local url
      url=$(echo "$INPUT_FORMULA_URLS" | jq -r --arg k "${platform}-${arch}" '.[$k] // empty')
      [ -z "$url" ] && return

      python3 - "$FILE_PATH" "$os_block" "$cpu_check" "$sha" "$url" <<'PYEOF'
import sys, re
path, os_block, cpu_check, sha, url = sys.argv[1:6]
with open(path) as f:
    content = f.read()
pattern = rf'({os_block}\s+do.*?{re.escape(cpu_check)}.*?url\s+")[^"]*(".*?sha256\s+")[^"]*(")'
def replacer(m):
    return m.group(0)
lines = content.split('\n')
in_os = False
in_cpu = False
result = []
for line in lines:
    if os_block in line:
        in_os = True
    if in_os and cpu_check in line:
        in_cpu = True
    if in_cpu and 'url "' in line:
        line = re.sub(r'url "[^"]*"', f'url "{url}"', line)
    if in_cpu and 'sha256 "' in line:
        line = re.sub(r'sha256 "[^"]*"', f'sha256 "{sha}"', line)
        in_cpu = False
    if in_os and line.strip() == 'end' and not in_cpu:
        in_os = False
    result.append(line)
with open(path, 'w') as f:
    f.write('\n'.join(result))
PYEOF
    }

    for platform in darwin linux; do
      for arch in arm64 x86_64; do
        update_formula_sha "$platform" "$arch"
      done
    done
  fi

  echo "::endgroup::"
  COMMIT_VERB="update"
else
  echo "::group::Create new $TYPE"
  mkdir -p "$(dirname "$FILE_PATH")"
  CASK_TOKEN=$(basename "$FILE_PATH" .rb)

  if [ "$TYPE" = "cask" ]; then
    {
      echo "cask \"${CASK_TOKEN}\" do"
      echo "  version \"${VERSION}\""

      if [ -n "${SHAS[x86_64]:-}" ]; then
        echo ""
        echo "  on_arm do"
        echo "    sha256 \"${SHAS[arm64]}\""
        echo ""
        echo "    url \"${INPUT_DMG_URL}\""
        echo "  end"
        echo "  on_intel do"
        echo "    sha256 \"${SHAS[x86_64]}\""
        echo ""
        echo "    url \"${INPUT_DMG_X86_URL}\""
        echo "  end"
      else
        echo "  sha256 \"${SHAS[arm64]}\""
        echo ""
        echo "  url \"${INPUT_DMG_URL}\""
      fi

      echo ""
      echo "  name \"${APP_NAME}\""
      echo "  desc \"${DESC}\""
      echo "  homepage \"${HOMEPAGE}\""
      echo ""
      echo "  livecheck do"
      echo "    url :url"
      echo "    strategy :github_latest"
      echo "  end"
      echo ""
      echo "  depends_on macos: \">= ${INPUT_MIN_MACOS}\""
      echo ""
      echo "  app \"${APP_NAME}.app\""
      echo ""
      echo "  postflight do"
      echo "    system_command \"xattr\", args: [\"-cr\", \"#{appdir}/${APP_NAME}.app\"]"
      echo "  end"
      echo ""
      echo "  zap trash: ["
      echo "    \"~/.config/${APP_LOWER}\","
      echo "    \"~/Library/Preferences/${BUNDLE_ID}.plist\","
      echo "    \"~/Library/Saved Application State/${BUNDLE_ID}.savedState\","
      echo "  ]"
      echo "end"
    } > "$FILE_PATH"
  else
    CLASS_NAME=$(echo "$CASK_TOKEN" | perl -pe 's/(^|[-_])(\w)/uc($2)/ge')
    {
      echo "class ${CLASS_NAME} < Formula"
      echo "  desc \"${DESC}\""
      echo "  homepage \"${HOMEPAGE}\""
      echo "  version \"${VERSION}\""
      [ -n "$INPUT_LICENSE" ] && echo "  license \"${INPUT_LICENSE}\""
      echo ""

      for os in macos linux; do
        platform_key=$( [ "$os" = "macos" ] && echo "darwin" || echo "linux" )
        arm_url=$(echo "$INPUT_FORMULA_URLS" | jq -r --arg k "${platform_key}-arm64" '.[$k] // empty')
        x86_url=$(echo "$INPUT_FORMULA_URLS" | jq -r --arg k "${platform_key}-x86_64" '.[$k] // empty')
        [ -z "$arm_url" ] && [ -z "$x86_url" ] && continue

        echo "  on_${os} do"
        if [ -n "$arm_url" ]; then
          echo "    if Hardware::CPU.arm?"
          echo "      url \"${arm_url}\""
          echo "      sha256 \"${SHAS[${platform_key}_arm64]}\""
        fi
        if [ -n "$x86_url" ]; then
          [ -n "$arm_url" ] && echo "    else" || echo "    if Hardware::CPU.intel?"
          echo "      url \"${x86_url}\""
          echo "      sha256 \"${SHAS[${platform_key}_x86_64]}\""
        fi
        echo "    end"
        echo "  end"
        echo ""
      done

      echo "  def install"
      echo "    bin.install \"${BIN}\""
      echo "  end"
      echo ""
      echo "  test do"
      echo "    system \"#{bin}/${BIN}\", \"--version\""
      echo "  end"
      echo "end"
    } > "$FILE_PATH"
  fi

  echo "::endgroup::"
  COMMIT_VERB="add"
fi

echo "::group::Result"
cat "$FILE_PATH"
echo "::endgroup::"

# --- Commit and push ---

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add "$FILE_PATH"
git commit -m "chore(${TYPE}): ${COMMIT_VERB} ${APP_NAME} v${VERSION}"
git push -u origin "$BRANCH"

# --- Create PR ---

BODY="Automated by [brew-releaser](https://github.com/${TAP_REPO}/tree/main/actions/brew-releaser).\n\n"
BODY+="| Field | Value |\n|---|---|\n"
BODY+="| **Type** | \`${TYPE}\` |\n"
BODY+="| **Version** | \`${VERSION}\` |\n"
for key in "${!SHAS[@]}"; do
  label=$(echo "$key" | tr '_' '-')
  BODY+="| **SHA256 (${label})** | \`${SHAS[$key]}\` |\n"
done

RESPONSE=$(curl -fsSL -X POST \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/${TAP_REPO}/pulls" \
  -d "$(jq -n \
    --arg title "chore(${TYPE}): ${APP_NAME} v${VERSION}" \
    --arg body "$BODY" \
    --arg head "$BRANCH" \
    --arg base "main" \
    '{title: $title, body: $body, head: $head, base: $base}')")

PR_URL=$(echo "$RESPONSE" | jq -r '.html_url // empty')
echo "pr_url=$PR_URL" >> "$GITHUB_OUTPUT"
echo "Pull request: $PR_URL"
