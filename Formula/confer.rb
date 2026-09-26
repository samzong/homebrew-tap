class Confer < Formula
  desc "Local multi-agent rooms over MCP"
  homepage "https://github.com/samzong/confer"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    if Hardware::CPU.arm?
      url "https://github.com/samzong/confer/releases/download/v0.2.2/confer-v0.2.2-darwin-arm64.tar.gz"
      sha256 "564f3b298c45475bcad3593f222bb870593f99807234c78f5a951eb83ab343ec"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    if Hardware::CPU.intel?
      url "https://github.com/samzong/confer/releases/download/v0.2.2/confer-v0.2.2-linux-x86_64.tar.gz"
      sha256 "c58842fcff12bd8a01c5c529de131120279e855560dc70e210440bf6cec466b0"
    end
  end

  def install
    bin.install "confer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/confer --version")
  end
end
