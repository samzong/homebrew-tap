cask "configforge" do
  version "0.1.0"

  name "ConfigForge"
  desc "Open-source SSH configuration and Kubernetes configuration management tool"
  homepage "https://github.com/samzong/ConfigForge"

  auto_updates true

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  on_arm do
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
    sha256 "28b92928e9c5258d230cdeda6d26d97458c488f4020ada837a4528caf2561262"
  end

  on_intel do
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "9d064b031d282318107acc5100a4ec51c904c8b9843f7d7f28bd01ebffbd3064"
  end

  app "ConfigForge.app"
  binary "#{appdir}/ConfigForge.app/Contents/Resources/bin/cf"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/ConfigForge.app"]
  end
  
  zap trash: [
    "/Library/Logs/DiagnosticReports/ConfigForge*",
    "~/.config/configforge",
    "~/.ssh/config.d/configforge*",
    "~/Library/Application Support/ConfigForge",
    "~/Library/Caches/com.samzong.configforge",
    "~/Library/Containers/com.samzong.configforge",
    "~/Library/Group Containers/group.com.samzong.configforge",
    "~/Library/HTTPStorages/com.samzong.configforge",
    "~/Library/LaunchAgents/com.samzong.configforge.plist",
    "~/Library/Logs/ConfigForge",
    "~/Library/Preferences/ByHost/com.samzong.configforge.*.plist",
    "~/Library/Preferences/com.samzong.configforge.plist",
    "~/Library/Saved Application State/com.samzong.configforge.savedState",
    "~/Library/WebKit/com.samzong.configforge",
  ]
end
