class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.1.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_arm64.tar.gz"
      sha256 "5dd7440ebb8cf2920881576b86d187e8eba32cd1812a6c8f9e176430a0ad91a9"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_x86_64.tar.gz"
      sha256 "f97b4f09d6fb48a77770f44e83ec5024821e190e03f5d69dffb1f1d8ef7fd436"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_arm64.tar.gz"
      sha256 "d6ba41c9abe96a02cee25cf92560eabc4f6b7c1899fbad385b7ec7ecaf49dea1"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_x86_64.tar.gz"
      sha256 "8ef4ac7a396eec309d110826011b8aeb3e2dcd1e15dfe5cda28eb4985fe223a5"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
