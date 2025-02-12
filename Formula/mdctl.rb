class Mdctl < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.0.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "0caca892099bbf345c0d9e10beeea45c00cd54e916f10bcfe52954f84342365c"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "728b4846630693f009ebe49cf179a1ae59aafa5718c7ee4b4877ae0a9ed8c748"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "4a5abcfe768a332a5a25a5747a558c90b071a8304ab3359f002915d2986765e5"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "6f04559dcc3561461865b2bcf8f84a3173919412fe8d91cb98ab5966e8219de8"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end 