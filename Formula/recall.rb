class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.1.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "3728c649e93dde3c24caa7144384f4b63162f8b20680fa9ca68e42af53d07e8f"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "0d3bd00fb623c3b124a2b1e221f350495c7bca37b65f2d31d3b30aef75a9db15"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "27db5d3cab86a49dc0faa61e5acca940bb35cad8f740489af33af8e9ee70200c"
  end

  def install
    bin.install "recall"
  end

  test do
    system "#{bin}/recall", "--version"
  end
end
