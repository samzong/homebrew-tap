class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.5.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "750d225f15a208392a258a98489590db455ed754d43197e7cb751acff0bfb2fd"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "8ed120d86790979ef4ba8e6479bc9584d476c20f5f3923e0d7f2bc0ceba44627"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "0553dcd3bd8c4669abcdac643a465c34c362167319ff79a6c73ec3e59672109a"
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
