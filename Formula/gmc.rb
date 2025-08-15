class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.0.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "f54a4f753b3bb8aabe773a525a860aa5e89f88e3ebb3fa5104fec0557f74bf50"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "d14bd516aa9809ee637402428c3383251c9d8970a1566975746bfe414c08d303"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "859616d5e237eb377f952009a3a3c2f3d82b7fee3f293ee4b781f23f4d3d8cf1"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "abf0c4a3ede52ddcdd84e279551067637ed06bf7d8b104664fd628474289cf0f"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
