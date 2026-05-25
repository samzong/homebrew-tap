class Mdctl < Formula
  desc "CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.1.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "2d03eb35a5fa80b45d8bd65a3509ceba6fccd27d13dc0f8bed071c5214448904"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "4c48459efccf25ec20b28371ce68a3c848817f1f5256a0134fb4b3d9d0dcb007"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "9ed1446bcb54e2c7d47681f64e04294f40586a754567c3f3d7098d8546520107"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "730a1ae9c43711cf19c5b7b5ba51bf05faae11b3d0dfa1e8efda8668846016bc"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end
