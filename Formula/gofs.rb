class Gofs < Formula
  desc "A lightweight, fast HTTP file server written in Go."
  homepage "https://github.com/samzong/gofs"
  version "0.1.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_arm64.tar.gz"
      sha256 "0d5ae0bf5203c1c4f0a02691dd8742664b991f4ae8f3350fdc14f54cd23c4521"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Darwin_x86_64.tar.gz"
      sha256 "0d7fc377be1d2f7f9e88f344a7e0d3a742189608fe84dc565cec24a8deb1a498"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_arm64.tar.gz"
      sha256 "fb92a71ef44193c078f8a1bc84693c1ffa00322e7aac1fd74da3972d54a85d52"
    else
      url "https://github.com/samzong/gofs/releases/download/v#{version}/gofs_Linux_x86_64.tar.gz"
      sha256 "94980e6126187fc9f4a681c9c37e6e1110eed16edad3d833efed9c71c4e56248"
    end
  end

  def install
    bin.install "gofs"
  end

  test do
    system "#{bin}/gofs", "--version"
  end
end
