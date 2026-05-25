class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.2.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "2c62c18c80fe7f32367c4925726cdb0af667904299d5bf59cfc5321afadf220c"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "6d6de980eb1fe3a721bf1a1345fa6643b14836e153faf5e0849317039d260e60"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "31125eeb58356b0d19cb11985650de13f822dd577e84504ae737ff98e17d8f3f"
  end

  def install
    bin.install "recall"
  end

  test do
    system "#{bin}/recall", "--version"
  end
end
