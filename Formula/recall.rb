class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.6.4"
  revision 1

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "222cbb5db560655b6e9171be6dd81a4c911cb1f8cc2e0136797016d6b8670c3d"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "12d0e94d3b607ca488b7cb332a024fdd58d028b1d4ec284ea909340dee3f3501"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "02edbee835d82638776bbbc9f07ff67b498116b881987485952f255e8d738847"
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
