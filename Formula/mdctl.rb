class Mdctl < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.1.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "9114c4d65dae19afffcd68e82c9e3e67a090c7a1dd5867fcf2e7f0f85acd4969"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "29c77ca5da3f53c3fb547ff883a89f9a85e509b9cdcbf3ff3d680143443438d0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "fef156f38ef04f8bfad03451083169d159ae57deaa56e8ff3f6ab890b303bf93"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "88508efa6f042d2b52c72ae7d889dde7e9cac82917519a61fe3ce12a11d6eaaa"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end 