class Confer < Formula
  desc "Local multi-agent rooms over MCP"
  homepage "https://github.com/samzong/confer"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    if Hardware::CPU.arm?
      url "https://github.com/samzong/confer/releases/download/v0.2.0/confer-v0.2.0-darwin-arm64.tar.gz"
      sha256 "229cbe3cc8dc49b4f9db2cd02fa816c96e0a064ea0497965269eade4ec949fe6"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    if Hardware::CPU.intel?
      url "https://github.com/samzong/confer/releases/download/v0.2.0/confer-v0.2.0-linux-x86_64.tar.gz"
      sha256 "cf614cab5bc4dff6c0d33c7502082abb741700ddbe2028c2cef14ea6323e8706"
    end
  end

  def install
    bin.install "confer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/confer --version")
  end
end
