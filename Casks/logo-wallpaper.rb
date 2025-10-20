cask "logo-wallpaper" do
  version "0.0.0"

  on_arm do
    sha256 "a0af73be277d74ac2b330da6080c8e3d87f61d7c5d6e53973b62cf26e5425441"

    url "https://github.com/samzong/LogoWallpaper/releases/download/v#{version}/LogoWallpaper-arm64.dmg"
  end
  on_intel do
    sha256 "fafd0ac67446fa0e7317144960323abff4e9d6b166c80e39f6fe4aa2c88de8b9"

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
