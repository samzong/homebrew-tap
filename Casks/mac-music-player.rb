cask "mac-music-player" do
  version "0.1.5"

  url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-v#{version}.dmg"
  sha256 "a07796092a536d6b021e69f97c8984a61efbd709582e7bd27e0a86c619b06e97"

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