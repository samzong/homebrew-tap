class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.5.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "096ff68da72916713be31770156c8cbc140095085dda5e275390bca0b0639fd4"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "95e0e2ce28df1460e6546466e594effb6d66ce671d347ca1975e076c6a59726a"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "0de759765cad16663868d4c22518e2e39f17ebe3f4a0e2bbbeaa8cc590dce62d"
  end

  def install
    bin.install "recall"
    if version >= Version.new("0.5.1")
      bin.install "rx"
      %w[rxc rxx rxo rxp].each { |name| bin.install_symlink "rx" => name }
    end
  end

  test do
    system "#{bin}/recall", "--version"
    if version >= Version.new("0.5.1")
      system "#{bin}/rx", "--version"
      %w[rxc rxx rxo rxp].each do |name|
        assert_predicate bin/name, :symlink?
        assert_equal "rx", (bin/name).readlink.to_s
      end
    end
  end
end
