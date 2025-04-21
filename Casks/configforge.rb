cask "configforge" do
  app "ConfigForge.app"
  version "0.0.6"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "3685c6c6b9b877da287728960f725b4e043620b4eb51bdf94e997a7610b9a9b7"
  else
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "ab479c2ee0537fc88f3cbac7401c86ae6873c21f4e6bebbee7a43708f2314b90"
  end

  binary "#{appdir}/ConfigForge.app/Contents/Resources/bin/cf"
  
  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
