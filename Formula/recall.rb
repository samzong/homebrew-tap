class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.6.3"
  revision 1

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "deb73f3f03e3883abb2957d698a35166ebe2eb54c7bb45dfd59b0a7c55674687"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "91d66d9efc6823c37925380094935b443a9d7bde5fa7f3031bd4a0083ede5453"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "b87959c8d3e820f01e41540ed8a6351d161590f74990ea8687c31499c2d6be2e"
  end

  def install
    bin.install "recall"
  end

  def caveats
    "rx is now installed separately: brew install samzong/tap/rx"
  end

  test do
    system "#{bin}/recall", "--version"
  end
end
