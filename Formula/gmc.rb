class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.0.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "ae0aba6cdcbbb1cb9e60eb9fa77c49551639cb1e5fc9a2ad3445e84d8de07408"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "33016083d79e756ed56e53fd6729571c1f5f060fadb36cffbc028f112f2e3228"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "2e39a710462553de61df588ee89415077d2a61d0205392a62d2e8413aedfb604"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "f5a87723f40c6251f6f1aff5dd22acb524c48fc2cd1f8bb3cd78863723e91488"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
