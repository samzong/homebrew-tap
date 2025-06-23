cask "saveeye" do
  version "1.0.7"

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
    sha256 "0b21a6fee22f4bdc5d53f53a89731ad01b7222fe8f79ac238fd8dd6b0f4713db"
  end

  on_intel do
    url "https://github.com/samzong/SaveEye/releases/download/v#{version}/SaveEye-#{version}-x86_64.dmg"
    sha256 ""
  end

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
