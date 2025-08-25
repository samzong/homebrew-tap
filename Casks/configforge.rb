cask "configforge" do
  version "0.2.1"

  on_arm do
    sha256 "ed076132dd1c0554471b9045df720ed8a01a8cda16bae353bf02960912810081"

    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-arm64.dmg"
  end
  on_intel do
    sha256 "11880d52f3248e03ed20f9345c5b7c30a5cbbdbc5d28906d0e9a67d3d4bcbd0a"

    url "https://github.com/samzong/ConfigForge/releases/download/v#{version}/ConfigForge-x86_64.dmg"
  end

  name "ConfigForge"
  desc "Open-source SSH configuration and Kubernetes configuration management tool"
  homepage "https://github.com/samzong/ConfigForge"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

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
