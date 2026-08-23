class Recall < Formula
  desc "Local-first TUI for searching AI coding session history"
  homepage "https://github.com/samzong/Recall"
  version "0.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-aarch64.tar.gz"
      sha256 "ab950f0f114bbcf32930a4ef53061c9ba09849b600e0f65beb59813da7a402a8"
    else
      url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-macos-x86_64.tar.gz"
      sha256 "fb1c0668a57af48d7935aebb1b9847dcb6463e31000fa4bbe2ccfad6d35ca0d6"
    end
  end

  on_linux do
    url "https://github.com/samzong/Recall/releases/download/v#{version}/recall-linux-x86_64.tar.gz"
    sha256 "50616a2f5afe828107f04450f732c6a7b5025086fb35bcde94f07d3497cb2cf7"
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
