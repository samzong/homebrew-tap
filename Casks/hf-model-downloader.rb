cask "hf-model-downloader" do
  app "HF Model Downloader.app"
  version "0.0.6"

  name "HF Model Downloader"
  desc "A GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"

  auto_updates true

  if Hardware::CPU.arm?
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.dmg"
    sha256 "80385b7a008ef378a1c8b364128584957bb84ecac7b6a5d8255dd8a5aa11d2cc"
  else
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-x86_64.dmg"
    sha256 "627685831a39633671cecab9be2ba4bcb6020ed15e0351c8fb44a0664f494fa6"
  end

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/HF Model Downloader.app"]
  end

  zap trash: [
    "~/Library/Application Support/HF Model Downloader",
    "~/Library/Preferences/com.samzong.hf-model-downloader.plist",
    "~/Library/Saved Application State/com.samzong.hf-model-downloader.savedState",
    "~/Library/Caches/com.samzong.hf-model-downloader",
  ]
end
