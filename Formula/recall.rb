class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.5.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "9e98a49f6117d7af7a94ca01f69b640f7cad88c7f131fd2d1f5d1a269914f444"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "8e8649d2a0d91f1d9c394bb62223c4852dc6384b90ad5f9f7c3fb946187b784a"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "1d64e94f75427e1ec939fc0b2d3103f1314112e49c668689fcb16f91119e3a87"
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
