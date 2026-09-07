class Confer < Formula
  desc "Local multi-agent rooms over MCP"
  homepage "https://github.com/samzong/confer"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    if Hardware::CPU.arm?
      url "https://github.com/samzong/confer/releases/download/v0.2.1/confer-v0.2.1-darwin-arm64.tar.gz"
      sha256 "70dd204a52a0590d5f8901710d0a3dbdc1b92ced3ee6177e94086327b312d3dd"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    if Hardware::CPU.intel?
      url "https://github.com/samzong/confer/releases/download/v0.2.1/confer-v0.2.1-linux-x86_64.tar.gz"
      sha256 "e13af74a171c115f2e4ef858205d029aa61cd7bf66b29b2ece889e986a04b9be"
    end
  end

  def install
    bin.install "confer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/confer --version")
  end
end
