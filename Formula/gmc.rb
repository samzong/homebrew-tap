class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.6.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "8f49642436c00917c4fb673da948b2a2aeee8d9b8eb439dc2159b27c9c566cb7"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "4d067b6b6559e8d75cd1d2d35d6c0f3f4169c37d681fef83db3338f1e938d2d8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "c0ed5349150efd2ccf8817e000dd03c5f8520e2782b567dc305ff461dd26a555"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "94d2a206ce5281341fdbc2b05671186e5eb9eb00e9269d18c65a0ae43aa15a9e"
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
