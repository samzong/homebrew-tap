class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "e9570158b93da73c1d76215caff96d95c074096a85bc37b658e68e2d1038bf23"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "bcb46edcefae40ed30a80732ae34487cd9c8cabd20de0ff00ac310b0d3d44446"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "f5d0b53ca1b1e7c6c1f551389ecff7a4bcbb6b683691bd148673681e49677b6f"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "c12e87660a51bf830a1272f0a874749920be15ffadad44af186303be400d8758"
    end
  end

  def install
    bin.install "gmc"
    man1.install Dir["docs/man/*.1"]
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
