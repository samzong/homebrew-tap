cask "configforge" do
  app "ConfigForge.app"
  version "0.0.2"

  name "ConfigForge"
  desc "ConfigForge is an open-source SSH configuration management tool for macOS."
  homepage "https://github.com/samzong/ConfigForge"
  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "7059ee6509b59657c6efab6650a0bae474b8f15215b8b192ae4b9f0c8ffc29d4"
  else
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "cdda0664b5d24148ac9855e03b548abe30d69a23460d362a5e5c357dca318dae"
  end

  zap trash: [
    "~/Library/Application Support/ConfigForge",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/Caches/com.samzong.configforge",
  ]
end
