cask "logo-wallpaper" do
  version "0.1.1"

  on_arm do
    sha256 "79871f6e547f2ebebbc95f7455958fe14b64caaee31151c650576b729d4be7ba"

    url "https://github.com/samzong/LogoWallpaper/releases/download/v#{version}/LogoWallpaper-arm64.dmg"
  end
  on_intel do
    sha256 "9c577582629b8e05687a00d057d41d99d6b58400fc5f669b3e63a217404f42b3"

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
