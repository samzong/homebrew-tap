class Mdctl < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.0.11"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "87d27ed8c90c00bf53f3fb2b43d4de48f798b21224529db4e498c93c7ea710c1"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "41b95fccd7e3770a9f8b9d8b636fcf37f357a74d3521cf88efcaa5cdc9c5d57a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "c709ca5e1e4cbf48c8f70aa4ed1ebbe7687aeda13431f04f174f775742ddae4d"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "d30d4727eb24dcf95dbc0d903c20e52382641d9731904fdd4c123ef03c33573d"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end 