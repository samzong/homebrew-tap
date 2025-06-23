cask "saveeye" do
  version "latest"

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
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  end

  on_intel do
    url "https://github.com/samzong/SaveEye/releases/download/v#{version}/SaveEye-#{version}-x86_64.dmg"
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
