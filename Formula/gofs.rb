class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.1.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_arm64.tar.gz"
      sha256 "21ef2aac3f9aaa1577b8c89fd5f5c5e995562b5373ebb1cd83f5c93b5eccfefc"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_x86_64.tar.gz"
      sha256 "cb65419765a7f9dfaa54cdfee768ebecd7348e2dbe5af855d8d528d735cd3cc9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_arm64.tar.gz"
      sha256 "158cbbf47f4d7d488ceb3bd46d8cc9796325db8d43d5615f99aaa498799f287a"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_x86_64.tar.gz"
      sha256 "2cee48c20da9f4905b81aefadaa8800d158b92f5121e61fa625d9946b64f3b2a"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
