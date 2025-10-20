cask "logo-wallpaper" do
  version "0.1.3"

  on_arm do
    sha256 "80e6a80bf9fd24c0190b606dcf1d00cce5f6c20eadefd38ada019111ddef9e8c"

    url "https://github.com/samzong/LogoWallpaper/releases/download/v#{version}/LogoWallpaper-arm64.dmg"
  end
  on_intel do
    sha256 "8dd5b2b391a95c5a1c7b8d2b20b8af1d36e3f52a462a596179d84e7f1f31893f"

    url "https://github.com/samzong/LogoWallpaper/releases/download/v#{version}/LogoWallpaper-x86_64.dmg"
  end

  name "LogoWallpaper"
  desc "A wallpaper application for macOS"
  homepage "https://github.com/samzong/LogoWallpaper"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "LogoWallpaper.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/LogoWallpaper.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/LogoWallpaper*",
    "~/Library/Application Support/LogoWallpaper",
    "~/Library/Caches/com.samzong.LogoWallpaper",
    "~/Library/Containers/com.samzong.LogoWallpaper",
    "~/Library/Group Containers/group.com.samzong.LogoWallpaper",
    "~/Library/HTTPStorages/com.samzong.LogoWallpaper",
    "~/Library/LaunchAgents/com.samzong.LogoWallpaper.plist",
    "~/Library/Logs/LogoWallpaper",
    "~/Library/Preferences/ByHost/com.samzong.LogoWallpaper.*.plist",
    "~/Library/Preferences/com.samzong.LogoWallpaper.plist",
    "~/Library/Saved Application State/com.samzong.LogoWallpaper.savedState",
    "~/Library/WebKit/com.samzong.LogoWallpaper",
  ]
end
