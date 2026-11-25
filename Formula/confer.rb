class Confer < Formula
  desc "Local multi-agent rooms over MCP"
  homepage "https://github.com/samzong/confer"
  version "0.2.4"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    if Hardware::CPU.arm?
      url "https://github.com/samzong/confer/releases/download/v#{version}/confer-v#{version}-darwin-arm64.tar.gz"
      sha256 "8af1a93754acbb5058dd38991f986e457ba3db63eebc4fb95b0833cc4a1d17ee"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    if Hardware::CPU.intel?
      url "https://github.com/samzong/confer/releases/download/v#{version}/confer-v#{version}-linux-x86_64.tar.gz"
      sha256 "3201822b38812574a403bf3e44ce03849179da0253de91d5097ab645d9814b3c"
    end
  end

  def install
    bin.install "confer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/confer --version")
  end
end
