cask "hf-model-downloader" do
  version "0.0.3"

  if Hardware::CPU.arm?
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.dmg"
    sha256 "4b329c621bd75c1aaa345961b86a28cba1c02d861609085c49d1e39e1a7a89dc"
    app "HF Model Downloader.app"
  else
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-x86_64.dmg"
    sha256 "b2b4f5373fc9ce6bc3c44323c742d872c46954cec579ad48f9a20d2b66e6d029"
    app "HF Model Downloader.app"
  end

  name "HF Model Downloader"
  desc "A GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"
end 