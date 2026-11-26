cask "lunt" do
  version "0.6.0"

  on_arm do
    sha256 "7ba358e23ce3e27a66a7507dc002490d4fd96f6d998bc6d4d1bc7a77fc394b6d"

    url "https://github.com/samzong/lunt/releases/download/v#{version}/Lunt-#{version}-arm64.dmg"
  end
  on_intel do
    sha256 "71b377112c172d6086a02352313fee54480603c10c41a823d1a3d4fd67c33c6a"

    url "https://github.com/samzong/lunt/releases/download/v#{version}/Lunt-#{version}-x86_64.dmg"
  end

  name "Lunt"
  desc "Quiet menubar hub for GitHub work"
  homepage "https://github.com/samzong/lunt"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Lunt.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Lunt.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/Lunt*",
    "~/Library/Application Support/Lunt",
    "~/Library/Caches/com.samzong.lunt",
    "~/Library/HTTPStorages/com.samzong.lunt",
    "~/Library/Logs/Lunt",
    "~/Library/Preferences/ByHost/com.samzong.lunt.*.plist",
    "~/Library/Preferences/com.samzong.lunt.plist",
    "~/Library/Saved Application State/com.samzong.lunt.savedState",
  ]
end
