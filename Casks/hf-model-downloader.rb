cask "hf-model-downloader" do
  version "0.5.1"

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
    sha256 "d5182f4c0b8222c0dd90dcbc70e32421888eb8461e862dfe4880bc57c0e8c8b8"
  end

  on_intel do
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-x86_64.dmg"
    sha256 "9a225e30b6e68b26da75a4cff336cde9c7fd8d115110ca1f87ac542ab547039c"
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
