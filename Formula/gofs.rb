class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.1.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_arm64.tar.gz"
      sha256 "72a5ea19aebb669609da6344f96702b620ef3ed201fab95744aa49d72364e588"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_x86_64.tar.gz"
      sha256 "ceed3aa3dde8aec7abaae3d717e6b10a81af503190df60226a99f293e6404ef2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_arm64.tar.gz"
      sha256 "6588fce6651361dd526427f88b07406604c1f1006d94906e1521bf1b8733370e"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_x86_64.tar.gz"
      sha256 "84c4f5a01420c5d1f3257e1b801111ae4b198b363fb0e282fee496541c5d5335"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
