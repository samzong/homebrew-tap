class Blueprint < Formula
  desc "Agent-native web scaffolding"
  homepage "https://github.com/samzong/blueprint"
  url "https://github.com/samzong/blueprint/releases/download/v0.1.5/samzong-blueprint-0.1.5.tgz"
  sha256 "6bad1698265f57a4b2a79d664534c1f6bdf35b182b17a64b3e788b64eccff40a"
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
