cask "hf-model-downloader" do
  version "0.6.2"

  on_arm do
    sha256 "67ce25d4c8e92729bf39e9b49b195530e29c5d786edce496483aeba30dea2bba"

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
