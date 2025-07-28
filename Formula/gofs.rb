class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs-darwin-arm64"
      sha256 "46a9d07644a71c7206f804a54e6ee4f7179e2ae1bb103c7aed6815a0e7529fbf"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs-darwin-amd64"
      sha256 "8b14534b79dcf6a1bfc5d57a20ea7ce5eda54c36df69230e51e2af09f55638be"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs-linux-arm64"
      sha256 "828b85f5ff07545d04f5c648f18478f8ee37e194e437698f8f60891af9760f51"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs-linux-amd64"
      sha256 "575ad9f28ce60578c9e7765829ef434e67bfe0267749ebb280337389270c7508"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
