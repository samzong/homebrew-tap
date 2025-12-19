cask "mac-music-player" do
  version "0.5.0"

  on_arm do
    sha256 "255f01781031cd1d5979c51c517636773d30af2d4c4eee4ac46f277534fb41ae"

    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-arm64.dmg"
  end
  on_intel do
    sha256 "6565e2a30bcc4f942df711eae8decc453eb06d957b5f334147330b643a0f39b2"

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
