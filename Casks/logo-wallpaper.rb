cask "logo-wallpaper" do
  version "0.2.0"

  on_arm do
    sha256 "94d56b16e232154c5bcfdbf79b5278004aaabcfab3da73dfee1ea521b56dcc46"

    url "https://github.com/samzong/LogoWallpaper/releases/download/v#{version}/LogoWallpaper-arm64.dmg"
  end
  on_intel do
    sha256 "ca48c15d5e292a33ce134643b65112f285815a55aae598ee79d14b3583689caf"

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
