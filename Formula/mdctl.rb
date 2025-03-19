class Mdctl < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "231064dce55a6de51c41b6254a43f07762f44532cbb020ab808b4ae38ed931eb"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "29da5846e97fe28592dbc9f909304ef912905e489098e68c4f332ef1cd3cd4c4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "c160390810e79ef0b35888538f0a8b0bf1b8da5ca5ea0af77257ecc8c80f8a22"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "ed0e00e05090710bc2b75586a1fe6cf750ae5b2c2792fedc0db2d452ab7c7010"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end 