class Gmc < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/gmc"
  version "0.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "3e9f5b99db9e1d742415ae1581898bafccd027c81d5e6d32396671ece525ad80"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "120bb1c49069d98e77009f10ccdcea6cea6b04b44f4006afd81e770f21c6e3f8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "a335a2b934af83eeba415355ddc7406ab672117b3c7d0a5a4f48b64634561b0a"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "dc1be5173873f9832ad8988af2d73cd39acf449a440dbeda066d704be6ea84b6"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end 
