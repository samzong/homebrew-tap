class Blueprint < Formula
  desc "Agent-native web scaffolding"
  homepage "https://github.com/samzong/blueprint"
  url "https://github.com/samzong/blueprint/releases/download/v0.1.3/samzong-blueprint-0.1.3.tgz"
  sha256 "82e1be2dd9668dc11492a0ffbcf71b1de55bf037162ef47b47690cccae7735fe"
  license "MIT"

  depends_on "cloudflare-wrangler"
  depends_on "gofs"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blueprint --version")
  end
end
