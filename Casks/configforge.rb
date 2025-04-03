cask "configforge" do
  app "ConfigForge.app"
  version "0.0.1"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "5ed7a1d55bc7ef457da00ab17eb0a533f0120419236eb548168adb6ab5cbedc9"
  else
    url "https://github.com/samzong/MacMusicPlayer/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "6cf0aa4316394954705a8cf0be8c366fe433659b2ec8a9b2bceefbe0e5512a48"
  end

  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
