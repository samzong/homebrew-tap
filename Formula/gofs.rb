class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_arm64.tar.gz"
      sha256 "ae7210b3e9c3f57550d78b76f8df47160315fd9f40ff13dde340414dcea3ca2d"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_x86_64.tar.gz"
      sha256 "26867aa5b533a966eb949f826fe77ad2ed93046f21e67b1ff39bdd50b24693bc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_arm64.tar.gz"
      sha256 "711f67b43452e7599ae5b38385256f1418afd4e9f9e208240358181376d1bc81"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_x86_64.tar.gz"
      sha256 "6d98385b0d88623ee710c648a7dbb557ff2a495d356189f8261e99943c5cca69"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
