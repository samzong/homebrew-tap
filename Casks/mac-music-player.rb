cask "mac-music-player" do
  version "0.2.1"

  url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer.dmg"
  sha256 "7fcdb71c7817ed55a9aa26ee0e6296b31e997381c562716d5ab4bb188f2ea989"

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
