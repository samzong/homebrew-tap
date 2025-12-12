class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.3.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "a374bde9691ed8bcca3e404b29793428594b92af73a5a61fb508b82e3766b87b"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "1c0fe82db705f2250f661eaaf0552ae91de68c7ddcdd7a3414b40ba8cfdb5de6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "37ee387c159fcb78e35b2fe726e2a34a0555e3dc1c6a0d0e21ebcd70a842d255"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "b63567538f4310a408f78aac83f85cb6b94e95bbf471ad76e414ba83b35e2c31"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
