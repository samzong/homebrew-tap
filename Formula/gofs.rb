class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.2.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_arm64.tar.gz"
      sha256 "bff8c1c23f3340e74db139da4d2f60dcd5ba1dc73d37842141a5a339db2ab94c"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_x86_64.tar.gz"
      sha256 "32d3757b8dfd3ffe518a954d42b77b884a1a05272e805d2c81612b4da414c99b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_arm64.tar.gz"
      sha256 "3820b4d0694bfa1eeb7d09219e186eb2eb431acfb15f16f36357e958cd65751b"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_x86_64.tar.gz"
      sha256 "11cf3ce51c0ce83676a67feee242e1fdb50a736c1800e1c0685ff82f30b1d345"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
