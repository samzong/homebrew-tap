cask "saveeye" do
  version "1.1.0"

  on_arm do
    sha256 "82029ab8388b04100dcfd3c20b27e6ad6c08aa8b20f0121e9ec2e99dac1f1f7a"

    url "https://github.com/samzong/SaveEye/releases/download/v#{version}/SaveEye-#{version}-arm64.dmg"
  end

  name "SaveEye"
  desc "Minimalist eye care reminder app"
  homepage "https://github.com/samzong/SaveEye"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "SaveEye.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/SaveEye.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/SaveEye*",
    "~/Library/Application Support/SaveEye",
    "~/Library/Caches/com.samzong.saveeye",
    "~/Library/Containers/com.samzong.saveeye",
    "~/Library/Group Containers/group.com.samzong.saveeye",
    "~/Library/HTTPStorages/com.samzong.saveeye",
    "~/Library/LaunchAgents/com.samzong.saveeye.plist",
    "~/Library/Logs/SaveEye",
    "~/Library/Preferences/ByHost/com.samzong.saveeye.*.plist",
    "~/Library/Preferences/com.samzong.saveeye.plist",
    "~/Library/Saved Application State/com.samzong.saveeye.savedState",
  ]
end
