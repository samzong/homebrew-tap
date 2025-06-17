cask "configforge" do
  app "ConfigForge.app"
  version "0.1.0"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "28b92928e9c5258d230cdeda6d26d97458c488f4020ada837a4528caf2561262"
  else
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "9d064b031d282318107acc5100a4ec51c904c8b9843f7d7f28bd01ebffbd3064"
  end

  binary "#{appdir}/ConfigForge.app/Contents/Resources/bin/cf"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/ConfigForge.app"]
  end
  
  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
