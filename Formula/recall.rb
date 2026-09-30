class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.6.2"
  revision 1

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "bc884cef2d1918a48bfa505e50a552db949f7e526d961646c7b91a8b44cd17b0"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "920d0d68514f424162642cf207d6b488c7ec8f6d54b67403a9ec97e92100f302"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "9b6bc8446adb064a88f5a5ab79b752c5f3fe00f7c572155425a6797ad14b75e3"
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
