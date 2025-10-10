cask "mac-music-player" do
  version "0.4.5"

  on_arm do
    sha256 "a0af73be277d74ac2b330da6080c8e3d87f61d7c5d6e53973b62cf26e5425441"

    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-arm64.dmg"
  end
  on_intel do
    sha256 "fafd0ac67446fa0e7317144960323abff4e9d6b166c80e39f6fe4aa2c88de8b9"

    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-x86_64.dmg"
  end

  name "MacMusicPlayer"
  desc "Simple and elegant music player"
  homepage "https://github.com/samzong/MacMusicPlayer"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"
  depends_on formula: ["yt-dlp", "ffmpeg"]

  app "MacMusicPlayer.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/MacMusicPlayer.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/MacMusicPlayer*",
    "~/Library/Application Support/MacMusicPlayer",
    "~/Library/Caches/com.samzong.macmusicplayer",
    "~/Library/Containers/com.samzong.macmusicplayer",
    "~/Library/Group Containers/group.com.samzong.macmusicplayer",
    "~/Library/HTTPStorages/com.samzong.macmusicplayer",
    "~/Library/LaunchAgents/com.samzong.macmusicplayer.plist",
    "~/Library/Logs/MacMusicPlayer",
    "~/Library/Preferences/ByHost/com.samzong.macmusicplayer.*.plist",
    "~/Library/Preferences/com.samzong.macmusicplayer.plist",
    "~/Library/Saved Application State/com.samzong.macmusicplayer.savedState",
    "~/Library/WebKit/com.samzong.macmusicplayer",
  ]
end
