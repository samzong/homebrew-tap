cask "hf-model-downloader" do
  version "0.6.5"

  on_arm do
    sha256 "7d6a099eedf56d0f175bd0a90e41829416f034eb78639cc972ffa264dc3e825c"

    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.dmg"
  end

  name "HF Model Downloader"
  desc "GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :big_sur

  app "HF Model Downloader.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/HF Model Downloader.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/HF Model Downloader*",
    "~/Library/Application Support/HF Model Downloader",
    "~/Library/Caches/com.samzong.hf-model-downloader",
    "~/Library/Containers/com.samzong.hf-model-downloader",
    "~/Library/Group Containers/group.com.samzong.hf-model-downloader",
    "~/Library/HTTPStorages/com.samzong.hf-model-downloader",
    "~/Library/LaunchAgents/com.samzong.hf-model-downloader.plist",
    "~/Library/Logs/HF Model Downloader",
    "~/Library/Preferences/ByHost/com.samzong.hf-model-downloader.*.plist",
    "~/Library/Preferences/com.samzong.hf-model-downloader.plist",
    "~/Library/Saved Application State/com.samzong.hf-model-downloader.savedState",
    "~/Library/WebKit/com.samzong.hf-model-downloader",
  ]
end
