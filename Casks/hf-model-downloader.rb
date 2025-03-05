cask "hf-model-downloader" do
  version "0.0.4"

  if Hardware::CPU.arm?
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-arm64.dmg"
    sha256 "185f00f235c4475be393d437007c8b0474007913e2693cb02a54cb1eca5150f0"
    app "HF Model Downloader.app"
  else
    url "https://github.com/samzong/hf-model-downloader/releases/download/v#{version}/hf-model-downloader-x86_64.dmg"
    sha256 "983d38d7be9ab3fbc570a97331688239a2f25945757ee4da657ae34584d3c5bd"
    app "HF Model Downloader.app"
  end

  name "HF Model Downloader"
  desc "A GUI tool for downloading Hugging Face models"
  homepage "https://github.com/samzong/hf-model-downloader"
end 