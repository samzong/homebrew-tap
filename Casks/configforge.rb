cask "configforge" do
  app "ConfigForge.app"
  version "0.0.1"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "d28900f29a753263675001e34246c4b58bb4676d49e475324b67fb0803cea775"
  else
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "c5a03673b6d693eadb97368b5ebed04b468185b3939c0dceed8449d58ad70b2d"
  end

  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
