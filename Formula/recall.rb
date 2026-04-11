class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.1.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "94a15e0d5e940a24a57cfd84802aaa80f51fd77ae5ba59c60602d5bbccbc1884"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "3eca099ef160961bae0205bc07e80e6a1e0dbc7a8e2edd23f7a6b633a95e3dbd"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "a9186a7e5b05c6ea7e0b4fa8e629807a8723094cdd1c6f1882bd8d52f5113493"
  end

  def install
    bin.install "recall"
  end

  test do
    system "#{bin}/recall", "--version"
  end
end
