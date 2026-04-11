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

gh_api() {
  local method="$1" endpoint="$2"
  shift 2
  curl -fsSL -X "$method" \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com${endpoint}" "$@"
}

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
SKIP_QUARANTINE="${INPUT_SKIP_QUARANTINE:-true}"
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

# --- Fetch existing file via API (no git clone) ---

echo "::group::Fetch tap state"
MAIN_SHA=$(gh_api GET "/repos/${TAP_REPO}/git/ref/heads/main" | jq -r '.object.sha')
echo "  main HEAD: $MAIN_SHA"

EXISTING_CONTENT=""
EXISTING_SHA=""
FILE_RESPONSE=$(gh_api GET "/repos/${TAP_REPO}/contents/${FILE_PATH}?ref=main" 2>/dev/null || echo '{"message":"Not Found"}')
if echo "$FILE_RESPONSE" | jq -e '.sha' &>/dev/null; then
  EXISTING_SHA=$(echo "$FILE_RESPONSE" | jq -r '.sha')
  EXISTING_CONTENT=$(echo "$FILE_RESPONSE" | jq -r '.content' | base64 -d)
  echo "  Found existing $FILE_PATH ($EXISTING_SHA)"
else
  echo "  $FILE_PATH not found — will create"
fi
echo "::endgroup::"

# --- Generate file content ---

echo "::group::Generate $TYPE content"

if [ -n "$EXISTING_CONTENT" ]; then
  NEW_CONTENT="$EXISTING_CONTENT"

  NEW_CONTENT=$(echo "$NEW_CONTENT" | sed 's/^  version "[^"]*"/  version "'"${VERSION}"'"/')

  if [ "$TYPE" = "cask" ]; then
    if echo "$NEW_CONTENT" | grep -q "on_arm"; then
      NEW_CONTENT=$(echo "$NEW_CONTENT" | sed '/on_arm/,/end/{s/sha256 "[^"]*"/sha256 "'"${SHAS[arm64]}"'"/;}')
      if [ -n "${SHAS[x86_64]:-}" ]; then
        NEW_CONTENT=$(echo "$NEW_CONTENT" | sed '/on_intel/,/end/{s/sha256 "[^"]*"/sha256 "'"${SHAS[x86_64]}"'"/;}')
      fi
    else
      NEW_CONTENT=$(echo "$NEW_CONTENT" | sed 's/^  sha256 "[^"]*"/  sha256 "'"${SHAS[arm64]}"'"/')
    fi
  else
    for platform in darwin linux; do
      for arch in arm64 x86_64; do
        safe="${platform}_${arch}"
        sha="${SHAS[$safe]:-}"
        [ -z "$sha" ] && continue
        url=$(echo "$INPUT_FORMULA_URLS" | jq -r --arg k "${platform}-${arch}" '.[$k] // empty')
        [ -z "$url" ] && continue

        [ "$platform" = "darwin" ] && os_block="on_macos" || os_block="on_linux"
        [ "$arch" = "arm64" ] && cpu_check="arm?" || cpu_check="intel?"

        NEW_CONTENT=$(python3 - "$os_block" "$cpu_check" "$sha" "$url" <<'PYEOF' <<< "$NEW_CONTENT"
import sys
os_block, cpu_check, sha, url = sys.argv[1:5]
content = sys.stdin.read()
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
        import re
        line = re.sub(r'url "[^"]*"', f'url "{url}"', line)
    if in_cpu and 'sha256 "' in line:
        import re
        line = re.sub(r'sha256 "[^"]*"', f'sha256 "{sha}"', line)
        in_cpu = False
    if in_os and line.strip() == 'end' and not in_cpu:
        in_os = False
    result.append(line)
print('\n'.join(result))
PYEOF
        )
      done
    done
  fi

  COMMIT_VERB="update"
else
  CASK_TOKEN=$(basename "$FILE_PATH" .rb)

  if [ "$TYPE" = "cask" ]; then
    NEW_CONTENT=$(cat <<EOF
cask "${CASK_TOKEN}" do
  version "${VERSION}"
EOF
    )

    if [ -n "${SHAS[x86_64]:-}" ]; then
      NEW_CONTENT+=$(cat <<EOF

  on_arm do
    sha256 "${SHAS[arm64]}"

    url "${INPUT_DMG_URL}"
  end
  on_intel do
    sha256 "${SHAS[x86_64]}"

    url "${INPUT_DMG_X86_URL}"
  end
EOF
      )
    else
      NEW_CONTENT+=$(cat <<EOF

  sha256 "${SHAS[arm64]}"

  url "${INPUT_DMG_URL}"
EOF
      )
    fi

    NEW_CONTENT+=$(cat <<EOF

  name "${APP_NAME}"
  desc "${DESC}"
  homepage "${HOMEPAGE}"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= ${INPUT_MIN_MACOS}"

  app "${APP_NAME}.app"
EOF
    )

    if [ "$SKIP_QUARANTINE" = "true" ]; then
      NEW_CONTENT+=$(cat <<EOF

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/${APP_NAME}.app"]
  end
EOF
      )
    fi

    NEW_CONTENT+=$(cat <<EOF

  zap trash: [
    "~/.config/${APP_LOWER}",
    "~/Library/Preferences/${BUNDLE_ID}.plist",
    "~/Library/Saved Application State/${BUNDLE_ID}.savedState",
  ]
end
EOF
    )
  else
    CLASS_NAME=$(echo "$CASK_TOKEN" | perl -pe 's/(^|[-_])(\w)/uc($2)/ge')
    NEW_CONTENT="class ${CLASS_NAME} < Formula
  desc \"${DESC}\"
  homepage \"${HOMEPAGE}\"
  version \"${VERSION}\""

    [ -n "$INPUT_LICENSE" ] && NEW_CONTENT+=$'\n'"  license \"${INPUT_LICENSE}\""
    NEW_CONTENT+=$'\n'

    for os in macos linux; do
      platform_key=$( [ "$os" = "macos" ] && echo "darwin" || echo "linux" )
      arm_url=$(echo "$INPUT_FORMULA_URLS" | jq -r --arg k "${platform_key}-arm64" '.[$k] // empty')
      x86_url=$(echo "$INPUT_FORMULA_URLS" | jq -r --arg k "${platform_key}-x86_64" '.[$k] // empty')
      [ -z "$arm_url" ] && [ -z "$x86_url" ] && continue

      NEW_CONTENT+=$'\n'"  on_${os} do"
      if [ -n "$arm_url" ]; then
        NEW_CONTENT+=$'\n'"    if Hardware::CPU.arm?"
        NEW_CONTENT+=$'\n'"      url \"${arm_url}\""
        NEW_CONTENT+=$'\n'"      sha256 \"${SHAS[${platform_key}_arm64]}\""
      fi
      if [ -n "$x86_url" ]; then
        [ -n "$arm_url" ] && NEW_CONTENT+=$'\n'"    else" || NEW_CONTENT+=$'\n'"    if Hardware::CPU.intel?"
        NEW_CONTENT+=$'\n'"      url \"${x86_url}\""
        NEW_CONTENT+=$'\n'"      sha256 \"${SHAS[${platform_key}_x86_64]}\""
      fi
      NEW_CONTENT+=$'\n'"    end"
      NEW_CONTENT+=$'\n'"  end"
      NEW_CONTENT+=$'\n'
    done

    NEW_CONTENT+=$'\n'"  def install"
    NEW_CONTENT+=$'\n'"    bin.install \"${BIN}\""
    NEW_CONTENT+=$'\n'"  end"
    NEW_CONTENT+=$'\n'
    NEW_CONTENT+=$'\n'"  test do"
    NEW_CONTENT+=$'\n'"    system \"#{bin}/${BIN}\", \"--version\""
    NEW_CONTENT+=$'\n'"  end"
    NEW_CONTENT+=$'\n'"end"
  fi

  COMMIT_VERB="add"
fi

echo "$NEW_CONTENT"
echo "::endgroup::"

# --- Push via GitHub API (no git clone) ---

echo "::group::Push to tap"
BRANCH="brew-releaser/${APP_LOWER}-${VERSION}"
ENCODED_CONTENT=$(echo "$NEW_CONTENT" | base64 | tr -d '\n')
COMMIT_MSG="chore(${TYPE}): ${COMMIT_VERB} ${APP_NAME} v${VERSION}"

gh_api POST "/repos/${TAP_REPO}/git/refs" \
  -d "$(jq -n --arg ref "refs/heads/${BRANCH}" --arg sha "$MAIN_SHA" \
    '{ref: $ref, sha: $sha}')" > /dev/null

if [ -n "$EXISTING_SHA" ]; then
  gh_api PUT "/repos/${TAP_REPO}/contents/${FILE_PATH}" \
    -d "$(jq -n \
      --arg message "$COMMIT_MSG" \
      --arg content "$ENCODED_CONTENT" \
      --arg sha "$EXISTING_SHA" \
      --arg branch "$BRANCH" \
      '{message: $message, content: $content, sha: $sha, branch: $branch}')" > /dev/null
else
  gh_api PUT "/repos/${TAP_REPO}/contents/${FILE_PATH}" \
    -d "$(jq -n \
      --arg message "$COMMIT_MSG" \
      --arg content "$ENCODED_CONTENT" \
      --arg branch "$BRANCH" \
      '{message: $message, content: $content, branch: $branch}')" > /dev/null
fi
echo "  Pushed $FILE_PATH to $BRANCH"
echo "::endgroup::"

# --- Create PR ---

echo "::group::Create PR"
BODY="Automated by [brew-releaser](https://github.com/${TAP_REPO}/tree/main/actions/brew-releaser).

| Field | Value |
|---|---|
| **Type** | \`${TYPE}\` |
| **Version** | \`${VERSION}\` |"

for key in "${!SHAS[@]}"; do
  label=$(echo "$key" | tr '_' '-')
  BODY+=$'\n'"| **SHA256 (${label})** | \`${SHAS[$key]}\` |"
done

RESPONSE=$(gh_api POST "/repos/${TAP_REPO}/pulls" \
  -d "$(jq -n \
    --arg title "chore(${TYPE}): ${APP_NAME} v${VERSION}" \
    --arg body "$BODY" \
    --arg head "$BRANCH" \
    --arg base "main" \
    '{title: $title, body: $body, head: $head, base: $base}')")

PR_URL=$(echo "$RESPONSE" | jq -r '.html_url // empty')
echo "pr_url=$PR_URL" >> "$GITHUB_OUTPUT"
echo "Pull request: $PR_URL"
echo "::endgroup::"
