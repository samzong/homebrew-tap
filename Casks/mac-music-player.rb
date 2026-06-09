cask "mac-music-player" do
  version "0.5.1"

  on_arm do
    sha256 "919f0abea39c170219691cd37f522efb5a28889cd889e1fc14b7519ba63ff868"

    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-arm64.dmg"
  end
  on_intel do
    sha256 "543fbadcf5f2867c1cf8c6d3a624729b1fea4edc75b337801dc935e51194bd76"

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
