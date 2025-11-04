class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.1.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "25038723b01eac8a83c7d69ba38c52a8dead50a69a3b59966a656ea5578e5458"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "748820e4e0cbae03f2cd2d524edca09a9f97093400e99f81a97b7a317d5cb644"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "0d00a016c02dc7949239f8c8f6a177ba03931918113ce641b17789e5079aeb28"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "0d37822ae1bff5a83103540024fcc6ae0eedb9cec49261f6bcfdfbb29458388e"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
