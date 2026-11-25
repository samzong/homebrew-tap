cask "mac-music-player" do
  version "0.6.1"

  on_arm do
    sha256 "3b77a0e70827a3397bcec74ceefdece2b5ab972e422a90651e61a7222472fa41"

    url "https://github.com/samzong/MacMusicPlayer/releases/download/v0.6.1/MacMusicPlayer-0.6.1-arm64.dmg"
  end

  name "MacMusicPlayer"
  desc "Simple and elegant music player"
  homepage "https://github.com/samzong/MacMusicPlayer"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura
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
