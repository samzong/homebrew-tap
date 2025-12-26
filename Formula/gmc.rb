class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.4.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "a896aba3917d3963f42741e5b18095685401bc80110499b469375c5b899ae6d3"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "edc219ab69466c108a60a459c9d2867d93da7e3cb4b2a7519a307ec375cdb05f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "407116dbfe77c6f7783d6316864d7ea779e57dfb7a0b5951f6e3f58a646fe2e4"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "5b8f2d8d791d5888167c092a61896cf3b72c0cd3607f694c740cb74d6debf3d6"
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
