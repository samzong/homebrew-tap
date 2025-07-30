class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.1.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_arm64.tar.gz"
      sha256 "f9ec8b889137e955a884fc0054e358d1d3287b8e8278f3f6a76a27c0e465f23a"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_x86_64.tar.gz"
      sha256 "bff25a788923c0027511804948b43fb2d70976bb35621dc9aaacdde3af3f0dd6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_arm64.tar.gz"
      sha256 "ee51c3e84f59b2c57521ff44845e6f304c0d308aedf0fabd36771e9ae48d4446"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_x86_64.tar.gz"
      sha256 "c16cab4e77698fbf773f605776ff02d318cace8b56106ffde19153617f659031"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
