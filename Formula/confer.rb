class Confer < Formula
  desc "Local multi-agent rooms over MCP"
  homepage "https://github.com/samzong/confer"
  version "0.3.0"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    if Hardware::CPU.arm?
      url "https://github.com/samzong/confer/releases/download/v#{version}/confer-v#{version}-darwin-arm64.tar.gz"
      sha256 "77582ee4bcdabc16dfaca4b2eee4ac6ec3615650c456cb734d8a50956a928ab7"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    if Hardware::CPU.intel?
      url "https://github.com/samzong/confer/releases/download/v#{version}/confer-v#{version}-linux-x86_64.tar.gz"
      sha256 "50c328aca318d334d396e9f7ba20a2be7d6d9cfe7115072be52ccdabbdfcfb18"
    end
  end

  def install
    bin.install "confer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/confer --version")
  end
end
