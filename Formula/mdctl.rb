class Mdctl < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "9fd86b0b4bff3592688f270fbebe78fd11306294be55a4d74ed4426d3b3d0bd2"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "82ba84d0ac8dbd4c7b192e55c2b926af4887c0181539416cee2e9a769124c29c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "ba2a6052b50ec3436445c5d485c7e2d156d88c6f2484c94fb77ada134b401757"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "b56745aa88b96338102979c0a5d73d108a76816041c3092dc0b9f1ec417302b1"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end 