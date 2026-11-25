cask "configforge" do
  version "0.2.3"

  on_arm do
    sha256 "72c63c852df74415705e2b77182387935d3ff30e5bbef4435685bc8ac4ce916f"

    url "https://github.com/samzong/ConfigForge/releases/download/v0.2.3/ConfigForge-0.2.3-arm64.dmg"
  end
  on_intel do
    sha256 "856a4ca4e41a485670ff539a2c7c5029b74618665ad3533b54b13637bc982a62"

    url "https://github.com/samzong/ConfigForge/releases/download/v0.2.3/ConfigForge-0.2.3-x86_64.dmg"
  end

  name "ConfigForge"
  desc "Open-source SSH configuration and Kubernetes configuration management tool"
  homepage "https://github.com/samzong/ConfigForge"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :big_sur

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
