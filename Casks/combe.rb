cask "combe" do
  version "0.2.1"

  on_arm do
    sha256 "256f3b19aeb0b1c4d21a3167ca445d7dd3c34ad7831eddd1cb38968ef01339b8"

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
