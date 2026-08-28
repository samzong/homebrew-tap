class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.5.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "c262a87829bc277a0358b9fddee8678dac34db45769cc5bdc2b306eebc90ea29"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "dbd0021d221e0a3c23cb4024bbd2a88a236e37ef2f4637ff4fe5d968d4d8405e"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "ad42014405e8c5305240d04bb547c1dc1353240db48d2d3ae0f34e94ceae85f6"
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
