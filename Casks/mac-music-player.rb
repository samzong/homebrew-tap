cask "mac-music-player" do
  version "0.1.7"

  url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-v#{version}.dmg"
  sha256 "510569bf8833c329652ceaea12035a773ba08a7e8181af3a392d0d68b8010d4b"

  name "MacMusicPlayer"
  desc "A simple and elegant music player for macOS"
  homepage "https://github.com/samzong/MacMusicPlayer"

  auto_updates true

  app "MacMusicPlayer.app"

  zap trash: [
    "~/Library/Application Support/MacMusicPlayer",
    "~/Library/Preferences/com.samzong.macmusicplayer.plist",
    "~/Library/Saved Application State/com.samzong.macmusicplayer.savedState",
    "~/Library/Caches/com.samzong.macmusicplayer",
  ]
end 