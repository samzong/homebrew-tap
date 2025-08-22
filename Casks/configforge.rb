cask "configforge" do
  version "0.2.0"

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
    sha256 "26563af0964119e00ad2139bb3ac77c7d7681bc546f0e22bcb92051e42457e55"
  end

  on_intel do
    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
    sha256 "cbd2b0ddd9e27161f863c3f84a4c9b0649535e8332ed7d54d6044626d0130f43"
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
