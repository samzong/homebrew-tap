class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.2.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "41144b4623d42e9908f52a75c51f0d5dec733cb1ce20c05288fadb13ac7593e4"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "df40a835931f420fd1a325628a11be7ffef761830bb86afa365662f5467db79f"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "c246db39f4498579d8cfaee983c414ce28c5b2e800f18885fcd51145af208e0f"
  end

  def install
    bin.install "recall"
  end

  test do
    system "#{bin}/recall", "--version"
  end
end
