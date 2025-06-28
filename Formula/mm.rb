class Mm < Formula
  desc "CLI for that help you fast to contribution to projects."
  homepage "https://github.com/samzong/mm"
  version "0.0.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_arm64.tar.gz"
      sha256 "6d3cb92506fae8b71b6812c818431c585a20e7c37d766c20ff6813bbf8e8b718"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_x86_64.tar.gz"
      sha256 "62bcb075c260e0d991ee8d2f7dab754f3f16b87c23d70c7d89130409ccfd8e78"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_arm64.tar.gz"
      sha256 "713ac452e90c43b6fad336882832a46a0bddf323e76536c6c07fcb570611fb26"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_x86_64.tar.gz"
      sha256 "ca2f4f4df797504ea0c963a96808b90a7ee11d8fadbe8b57348828ed9265cf9a"
    end
  end

  def install
    bin.install "mm"
  end

  depends_on "gh"

  test do
    system "#{bin}/mm", "--version"
  end
end
