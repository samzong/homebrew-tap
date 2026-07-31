class Blueprint < Formula
  desc "Agent-native web scaffolding"
  homepage "https://github.com/samzong/blueprint"
  url "https://github.com/samzong/blueprint/releases/download/v0.1.4/samzong-blueprint-0.1.4.tgz"
  sha256 "73c3ddc06647b5a7b651cdfe71cb304ebd1202d3018afb3399d42b3b77904708"
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
