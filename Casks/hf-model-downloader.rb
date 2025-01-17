cask "hf-model-downloader" do
  version "0.0.2"

  if Hardware::CPU.arm?
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.zip"
    sha256 "9b5cb4c54fc5691a4787fea1ddd203d27e1bf4791e35261b408f9057eb8d6f5c"
  end

  name "HF Model Downloader"
  desc "A GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"

  app "HF Model Downloader.app"
end 