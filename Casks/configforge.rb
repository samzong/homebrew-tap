cask "configforge" do
  app "ConfigForge.app"
  version "0.0.7"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "0c5649d0e2b07eb3f9a02d3e667d93b7b7f70f922c014898eb6c3ebf62856bbd"
  else
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "0303fa404ca911403d83363abf8b12d024145a900f9d5968ac9e2c69859c9a10"
  end

  binary "#{appdir}/ConfigForge.app/Contents/Resources/bin/cf"
  
  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
