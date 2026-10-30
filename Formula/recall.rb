class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.6.7"
  revision 1

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "4733e684dcc98f6226cfad1287fb7551cbed686874aea99ac86bbc919117277d"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "7c88d3d1bf27b8d613e69114493e803d7334d9f5e6585cc7b2f12ed0c7996a66"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "bd0e3595d6b03260bddcd8734acd80a73718f836f93331d3268838405f971b1f"
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
