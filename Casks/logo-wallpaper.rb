cask "logo-wallpaper" do
  version "0.1.2"

  on_arm do
    sha256 "a31cdf86864713f2a51f0cf00dee8dede3c9531307ff7054ea48c3560aeacc50"

    url "https://github.com/samzong/LogoWallpaper/releases/download/v#{version}/LogoWallpaper-arm64.dmg"
  end
  on_intel do
    sha256 "c1645b257ecd386c7cac3db84650e4e8b1473acb83cb4a964bcb92ba68a3f003"

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
