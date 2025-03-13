cask "mac-music-player" do
  app "MacMusicPlayer.app"
  version "0.2.3"

  name "MacMusicPlayer"
  desc "A simple and elegant music player for macOS"
  homepage "https://github.com/samzong/MacMusicPlayer"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-arm64.dmg"
    sha256 "ccce8afc3417313750edb1b7d1de075cdc2211e4b7b08db3df9639d2db7813c6"
  else
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/MacMusicPlayer-x86_64.dmg"
    sha256 "11300f72ed131fa322d60e47366a4de55d811a5517de5624d2cf27292c57e1df"
  end

  zap trash: [
    "~/Library/Application Support/MacMusicPlayer",
    "~/Library/Preferences/com.samzong.macmusicplayer.plist",
    "~/Library/Saved Application State/com.samzong.macmusicplayer.savedState",
    "~/Library/Caches/com.samzong.macmusicplayer",
  ]
end
