cask "combe" do
  version "0.2.7"

  on_arm do
    sha256 "88d31a05e8d3a4e36879d5dd9a27d4af3e574ee5958531307e7fdfcdca4cb0f8"

    url "https://github.com/samzong/combe/releases/download/v#{version}/Combe-v#{version}-macos-arm64.zip"
  end

  name "Combe"
  desc "A worktree-aware terminal for Apple Silicon. Curated catalog on the left, Ghostty surfaces on the right."
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
