class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "a2ccc0deda413408c9423af6300e0a3d0dba80d3ce48cab83b3a2c87301d714c"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "b5b88ca577ec75b1c31e74b61935213fe0cb867e5650db4787f1a259fe732334"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "b30b7036f7b86ba20e67b5b60e11d040a9069bd89b09234f22522196dbf11412"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "e23dfbacb95a4dd1ea8d4c97f97c71ca7b263871820f9a0863c8f4bf053cd503"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
