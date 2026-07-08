class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.3.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "af13a1730cdd2a5ec57a83d38368e949f9e493f419c3b92b5f9c39cf80c82edf"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "f5290d2fc941d965b5584281788c31f5a7baabfe7c137a983db4f7b3151f69e0"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "8e38cb858e46d7185f70aae1f9257f287253f142f6b2c0c05c1549ca0deb15bb"
  end

  def install
    bin.install "recall"
  end

  test do
    system "#{bin}/recall", "--version"
  end
end
