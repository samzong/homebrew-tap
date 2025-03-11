cask "mac-music-player" do
  version "0.2.0"

  url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer.dmg"
  sha256 "0dcc2a40a2edeb78821ebae61bb48e12f25340847b014f873f98ef9d30d5bfda"

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
