class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.6.5"
  revision 1

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "f8c2214fbb8bb4911ede0edc9dc0377c8db4dd9574c7935ca9a25e869048e077"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "ebff5ac967eb120f0d59e3a41b84cc7dec4b166935ffd9d4d9083752ee683d56"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "3e80935a3287a0dcd670a12cb45688251e0f083a7225301186cc475a3a8f826e"
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
