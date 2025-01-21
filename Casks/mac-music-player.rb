cask "mac-music-player" do
  version "v0.1.7"

  url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-v#{version}.dmg"
  sha256 "e69962cfb7bc79ff3eff58ef639315685088025d76aeac9f6c1ccd3a86e1cd3c"

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