cask "hf-model-downloader" do
  app "HF Model Downloader.app"
  version "0.0.5"

  name "HF Model Downloader"
  desc "A GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"

  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.dmg"
    sha256 "5784d3d16cc286fbad723a239aabef4ea49a8ccc7cac86c515d210feb340b88a"
  else
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-x86_64.dmg"
    sha256 "2cd4baceee1c8549c1d0be764dc2ab3b7266433e89bb9c61a5497c15e345f9f6"
  end

  zap trash: [
    "~/Library/Application Support/HF Model Downloader",
    "~/Library/Preferences/com.samzong.hf-model-downloader.plist",
    "~/Library/Saved Application State/com.samzong.hf-model-downloader.savedState",
    "~/Library/Caches/com.samzong.hf-model-downloader",
  ]
end
