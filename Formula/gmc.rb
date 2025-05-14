class Gmc < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/gmc"
  version "0.0.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "f980857b2231865a11e640d4a5be3fea1182cb56c95ee70e4759b2041e462a10"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "691fc452f73174dd4daa4c0440c88b08c6c08a3bcd1efe1cfa3c78f389722823"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "e44431893b6dc61d4ea896615c84ed683fe9c2f99ddd7113cc6d296b77e8c16f"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "2dd2b06fda3e98278182708a762a2cdfb4df827bd20cd461b09fb757f7072e85"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end 
