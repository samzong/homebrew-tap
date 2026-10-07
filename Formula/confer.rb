class Confer < Formula
  desc "Local multi-agent rooms over MCP"
  homepage "https://github.com/samzong/confer"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    if Hardware::CPU.arm?
      url "https://github.com/samzong/confer/releases/download/v0.2.3/confer-v0.2.3-darwin-arm64.tar.gz"
      sha256 "7b0178c1e8cf77244b05cef31f66a1f3f149e6155fdc1a126566f9d68a715fd3"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    if Hardware::CPU.intel?
      url "https://github.com/samzong/confer/releases/download/v0.2.3/confer-v0.2.3-linux-x86_64.tar.gz"
      sha256 "edec6c29e662370016ec8f4e33ab8e0a1b3f65c5c041a369e5f949961d226891"
    end
  end

  def install
    bin.install "confer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/confer --version")
  end
end
