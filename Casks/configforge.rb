cask "configforge" do
  app "ConfigForge.app"
  version "0.0.9"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "a9f30f4b9f86895ca0b2e31b005f3aeefe6908e6b6672a12db4792852cb25b76"
  else
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "2a6e7024a800b6dab19f13415d74357ad96ce614f53c539024c703394e94632a"
  end

  binary "#{appdir}/ConfigForge.app/Contents/Resources/bin/cf"
  
  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
