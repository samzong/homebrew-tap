class Mm < Formula
  desc "CLI for that help you fast to contribution to projects."
  homepage "https://github.com/samzong/mm"
  version "0.0.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_arm64.tar.gz"
      sha256 "f4d92305bbcd5e775c7dd5db5ef1643eaa1becca676468fb77ed1f3686ccace7"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_x86_64.tar.gz"
      sha256 "4fdfe4339a74af4ef74fdda9778556440edd9854da4f0b727fc6c9b777783815"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_arm64.tar.gz"
      sha256 "3597ccc555ed79369d0018bb194e9720f04cbd82291c7707a6de6f90e62ac594"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_x86_64.tar.gz"
      sha256 "5ae656a901adf6afd5bef8bfc6c5922ace8825119df0dd6a491c18cb883d2935"
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
