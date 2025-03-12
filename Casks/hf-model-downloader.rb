cask "hf-model-downloader" do
  app "HF Model Downloader.app"
  version "0.0.4"

  name "HF Model Downloader"
  desc "A GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"

  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.dmg"
    sha256 "185f00f235c4475be393d437007c8b0474007913e2693cb02a54cb1eca5150f0"
  else
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-x86_64.dmg"
    sha256 "983d38d7be9ab3fbc570a97331688239a2f25945757ee4da657ae34584d3c5bd"
  end

  zap trash: [
    "~/Library/Application Support/HF Model Downloader",
    "~/Library/Preferences/com.samzong.hf-model-downloader.plist",
    "~/Library/Saved Application State/com.samzong.hf-model-downloader.savedState",
    "~/Library/Caches/com.samzong.hf-model-downloader",
  ]
end
