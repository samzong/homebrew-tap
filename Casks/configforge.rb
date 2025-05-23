cask "configforge" do
  app "ConfigForge.app"
  version "0.0.10"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "288bec89ecf9e06cdf8380efd3dfece782cb1de48a069d0fa1f9328abe772223"
  else
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "5a4116d2ee01e0b0a3fbb786ae288f8c257c2a9226a0644de1badc57c2753f42"
  end

  binary "#{appdir}/ConfigForge.app/Contents/Resources/bin/cf"
  
  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
