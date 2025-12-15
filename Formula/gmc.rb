class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.3.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "5e1d98469ee918a7647a28f493fc989ff982e0b70f9137f1dc350b4666c3c7ef"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "066f26efe0f3ed66cb0109e74b5c38a9ad073948ecdd58766227802ea7fc86b9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "07ede315bfd332fe974d1d2edb8b3f28d67f1ce1398616fc5abc70775f3052e4"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "24ff2c115b1462156806f634146aed94baf8806ac705994a407c58795bd2228e"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
