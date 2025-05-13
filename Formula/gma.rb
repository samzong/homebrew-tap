class Gma < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/gma"
  version "0.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gma/releases/download/v#{version}/gma_Darwin_arm64.tar.gz"
      sha256 "892af3d54afda87193b28dac8dd9199e9435b597a0c71f949cfc46c36924855a"
    else
      url "https://github.com/samzong/gma/releases/download/v#{version}/gma_Darwin_x86_64.tar.gz"
      sha256 "15369d6f26aba72e76bdcca5152b900d892eb9bd310969559ab10948db3687d9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gma/releases/download/v#{version}/gma_Linux_arm64.tar.gz"
      sha256 "2afed70eae0fcd17f6e5de29626a5ac506d13c40663293227576e2b2fadbc8d6"
    else
      url "https://github.com/samzong/gma/releases/download/v#{version}/gma_Linux_x86_64.tar.gz"
      sha256 "ef2e08d9a00421aae58fef749dbb3f77d3c45b1e3f2839b6d6a2a5d1d7045550"
    end
  end

  def install
    bin.install "gma"
  end

  test do
    system "#{bin}/gma", "--version"
  end
end 
