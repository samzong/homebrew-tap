class Mdctl < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.0.10"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "6456e5cc03a085c5072fcae5f38ba42850239da9e23aeb642cc8cb742e1d7386"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "b8ef549f85f923efd4320f6e3c7050ce6a04d9601428d6369e7d7df1080de959"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "110b685322ca73cba004b6be5731925ef236542734909cc1d12c941d9b496ccc"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "ddbf0e2507360bd2e35d8a1cbf7ee275fa22397dbce27031b73ab3d0e6b9e721"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end 