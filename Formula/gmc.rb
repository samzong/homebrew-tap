class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "1.0.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v1.0.0/gmc_1.0.0_Darwin_arm64.tar.gz"
      sha256 "b8654467c1700b585192179777f064aabd75d7f786a4ade6ac9d5ecd29579b31"
    else
      url "https://github.com/samzong/gmc/releases/download/v1.0.0/gmc_1.0.0_Darwin_x86_64.tar.gz"
      sha256 "f36e1b5f0cfad44caab08e816460da8b4f24f948cebb82907b3844497ceb2b46"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v1.0.0/gmc_1.0.0_Linux_arm64.tar.gz"
      sha256 "5f0b135660bc83942c202a93840f589733530d4bcb34f29dfd37026d0580ebe6"
    else
      url "https://github.com/samzong/gmc/releases/download/v1.0.0/gmc_1.0.0_Linux_x86_64.tar.gz"
      sha256 "a3f481fec2d0c3cfdb080adfbc93272911e65d7cdc18c9015230270baa7a8edb"
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
