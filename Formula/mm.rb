class Mm < Formula
  desc "CLI for that help you fast to contribution to projects."
  homepage "https://github.com/samzong/mm"
  version "0.0.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_arm64.tar.gz"
      sha256 "03d5ca7de44813fa426755973c607efd5aa6526f0b1e7ef1459f9ee387b81b8e"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_x86_64.tar.gz"
      sha256 "66790c8218ca0194ab22f31059eac39cb23dd974a8875bff0b9db25857b7b186"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_arm64.tar.gz"
      sha256 "a189ed36d57895f8ebce8334f34c17e85c7fc10db13f17bb3d6d8fc04f3e3324"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_x86_64.tar.gz"
      sha256 "5e12b4f0ea3bc4466d3fb6f04094a779f3f0a38987adfd1a261ebdcebfe7a30b"
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
