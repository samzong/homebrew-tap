cask "combe" do
  version "0.2.5"

  on_arm do
    sha256 "5e4cfb16b036a10cd6075236ca3ea76d8a41998fc12c5d685b811e870bf0cb75"

    url "https://github.com/samzong/combe/releases/download/v#{version}/Combe-v#{version}-macos-arm64.zip"
  end

  name "Combe"
  desc "Worktree-aware terminal for Macs"
  homepage "https://github.com/samzong/combe"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura
  depends_on formula: "samzong/tap/gmc"
  depends_on cask: ["font-fira-code", "font-noto-sans-mono-cjk-sc"]

  app "Combe.app"
  binary "#{appdir}/Combe.app/Contents/MacOS/Combe", target: "combe"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Combe.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/Combe*",
    "~/Library/Application Support/combe",
    "~/Library/Caches/com.samzong.combe",
    "~/Library/HTTPStorages/com.samzong.combe",
    "~/Library/Logs/Combe",
    "~/Library/Preferences/ByHost/com.samzong.combe.*.plist",
    "~/Library/Preferences/com.samzong.combe.plist",
    "~/Library/Saved Application State/com.samzong.combe.savedState",
  ]
end
