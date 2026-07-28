class Blueprint < Formula
  desc "Agent-native web scaffolding"
  homepage "https://github.com/samzong/blueprint"
  url "https://github.com/samzong/blueprint/releases/download/v0.1.2/samzong-blueprint-0.1.2.tgz"
  sha256 "5f4cccebe9632fb6d1a2b9a4f224e5e3955b1b141bdb7535a6dcd3aae005c410"
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
