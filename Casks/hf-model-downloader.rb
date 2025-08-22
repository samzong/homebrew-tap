cask "hf-model-downloader" do
  version "0.5.4"

  name "HF Model Downloader"
  desc "A GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"

  auto_updates true

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  on_arm do
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.dmg"
    sha256 "da00e7f79cccd071b16762ac59811f9b80cb43d0ab06ddbf9e5cc9383130b42e"
  end

  on_intel do
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-x86_64.dmg"
    sha256 "e336250492b6517db2a5038b33aacd9853ad6e4ad63e822e81886049d91d97b9"
  end

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
