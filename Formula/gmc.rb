class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.1.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "227a171e0edb1eba846823f0c0aefc01d6a28464f0eb4dcf8067c672a03a1892"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "334c45959920197f5bc516657117fa3ebd8822d1a675548e06ea318d39c0abfc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "3f5b2832e222b7579d3f92840a3837fdf7f767a53abbf8a36b8755ed516b4de5"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "e2369d983c8068fea0076fafbb6594d83c383ad08762749801d08c65ed95a3f5"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
