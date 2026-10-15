class Blueprint < Formula
  desc "Agent-native web scaffolding"
  homepage "https://github.com/samzong/blueprint"
  url "https://github.com/samzong/blueprint/releases/download/v0.1.7/samzong-blueprint-0.1.7.tgz"
  sha256 "a6f1bd4d7ee5c84b5613009d2d77aa9a34abd2450fee497007d5a97b863372a6"
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
