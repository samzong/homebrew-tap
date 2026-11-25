class Blueprint < Formula
  desc "Agent-native web scaffolding"
  homepage "https://github.com/samzong/blueprint"
  version "0.2.0"
  url "https://github.com/samzong/blueprint/releases/download/v#{version}/samzong-blueprint-#{version}.tgz"
  sha256 "ff5ec5dbe5a503a6cb8e99f2aeca954f0d53f7d8d7550156faf2088e4b4ce5e1"
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
