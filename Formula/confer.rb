class Confer < Formula
  desc "Local multi-agent rooms over MCP"
  homepage "https://github.com/samzong/confer"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    if Hardware::CPU.arm?
      url "https://github.com/samzong/confer/releases/download/v0.1.0/confer-v0.1.0-darwin-arm64.tar.gz"
      sha256 "aaa3b0657e640dbb449a22e6b24333cfa3c56227d5f7f3252e93300be7d076b6"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    if Hardware::CPU.intel?
      url "https://github.com/samzong/confer/releases/download/v0.1.0/confer-v0.1.0-linux-x86_64.tar.gz"
      sha256 "71a87707bb9e10f30d9b5c132d89a7b91a938f16736abc42531f940486ea1366"
    end
  end

  def install
    bin.install "confer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/confer --version")
  end
end
