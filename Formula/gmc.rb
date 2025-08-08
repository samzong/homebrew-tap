class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.0.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "2277eb13a5cb892881f89cbec8e4177cb5f7fef976b479602981ba34c88ebce4"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "1563b8ae45453b321617f64e688d924a6dc91d50cba86b51674563444a7ae3bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "7e0538c9b849eeedd0cef0a32815898e10f18924fbe56e963b1505fdc2e38e98"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "acbf1e6c18bdac3b2214b92b5c4654f1f00b4efad0cb801ff7f27d40c839060c"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
