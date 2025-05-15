cask "mac-music-player" do
  version "0.3.0"
  if Hardware::CPU.arm?
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-arm64.dmg"
    sha256 "5257fd006d0bd6cc28d2f20587b49537d383bcd37d2c36877bb43d6184cc35f6"
  else
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-x86_64.dmg"
    sha256 "2e696b339725941e026262f7bf9a98e3eac136d216fbba197ba56e8bcc3a7ddc"
  end

  name "MacMusicPlayer"
  desc "A simple and elegant music player for macOS"
  homepage "https://github.com/samzong/MacMusicPlayer"
  auto_updates true

  depends_on macos: ">= :monterey"
  depends_on formula: ["yt-dlp", "ffmpeg"]

  app "MacMusicPlayer.app"

  zap trash: [
    "~/Library/Application Support/MacMusicPlayer",
    "~/Library/Preferences/com.samzong.macmusicplayer.plist",
    "~/Library/Saved Application State/com.samzong.macmusicplayer.savedState",
    "~/Library/Caches/com.samzong.macmusicplayer",
  ]
end
