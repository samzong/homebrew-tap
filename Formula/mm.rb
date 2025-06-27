class mm < Formula
  desc "CLI for that help you fast to contribution to projects."
  homepage "https://github.com/samzong/mm"
  version "0.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_arm64.tar.gz"
      sha256 "fcd4601e0528fe8f56b42fb168164d910fb50c144f41926fc2c819e0e002955a"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_x86_64.tar.gz"
      sha256 "1917168af4fa2c9ce980ef3311ab4cee9a1f2340a99988471e58dc7f4fe62753"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_arm64.tar.gz"
      sha256 "7db79d6b996dec9afae977f13e9269371074b24e11633833101fda82bf62063a"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_x86_64.tar.gz"
      sha256 "ed5415052e838d0b05f7d00b34b5bb6325f1a79cb218f566f39dda5366962bdc"
    end
  end

  def install
    bin.install "mm"
  end

  depends_on formula: ["gh"]

  test do
    system "#{bin}/mm", "--version"
  end
end
