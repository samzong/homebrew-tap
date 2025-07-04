cask "saveeye" do
  version "1.0.12"

  name "SaveEye"
  desc "minimalist eye care reminder app"
  homepage "https://github.com/samzong/SaveEye"

  auto_updates true

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  on_arm do
    url "https://github.com/samzong/SaveEye/releases/download/v#{version}/SaveEye-#{version}-arm64.dmg"
    sha256 "6e468b090d4b99e909aacab61fbeb0d6bc5963555ff66cea56719f2e19e51e01"
  end

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
