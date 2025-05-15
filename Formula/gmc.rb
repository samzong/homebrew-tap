class Gmc < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/gmc"
  version "0.0.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "631575a9207dbac7d675dc8448346f6067896d93c2f91b7b1ad0fc77e93d0016"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "6d5d7f85a1c51fee9d33f5e1ff5e5a86406ff62bbd46badd10988869081f358c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "fd4a6e23a29d1978d3ec88e6387d72bf56af3c9d467e1ff7de68f8e2d0b0af44"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "5eace8624529fdcf8d7d8f9da57e127ffc1213f28478ec3e4f870d2245faf411"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end 
