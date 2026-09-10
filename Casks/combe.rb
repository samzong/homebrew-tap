cask "combe" do
  version "0.2.0"

  on_arm do
    sha256 "1b78a30b829bdedd4813ecb6a60b60df604b794f7546ff14e4518985fc85cff6"

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

  app "Combe.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Combe.app"]
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
