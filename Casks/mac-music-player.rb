cask "mac-music-player" do
  app "MacMusicPlayer.app"
  version "0.2.5"

  name "MacMusicPlayer"
  desc "A simple and elegant music player for macOS"
  homepage "https://github.com/samzong/MacMusicPlayer"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-arm64.dmg"
    sha256 "5ed7a1d55bc7ef457da00ab17eb0a533f0120419236eb548168adb6ab5cbedc9"
  else
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-x86_64.dmg"
    sha256 "6cf0aa4316394954705a8cf0be8c366fe433659b2ec8a9b2bceefbe0e5512a48"
  end

  zap trash: [
    "~/Library/Application Support/MacMusicPlayer",
    "~/Library/Preferences/com.samzong.macmusicplayer.plist",
    "~/Library/Saved Application State/com.samzong.macmusicplayer.savedState",
    "~/Library/Caches/com.samzong.macmusicplayer",
  ]
end
