class Rx < Formula
  desc "Launch agent harnesses through a configured AI provider"
  homepage "https://github.com/samzong/rx"
  version "0.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-aarch64.tar.gz"
      sha256 "0159afb2b3065e803af5709adafff28fdd2af3fea55bc5cc9841e3940ebc1b77"
    else
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-x86_64.tar.gz"
      sha256 "7edd5126a77baac70937b4f738fca96eb5882f368e44627c1d42759b042adf52"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/samzong/rx/releases/download/v#{version}/rx-linux-x86_64.tar.gz"
    sha256 "6aa60105997f523fb74ec849b0393a6634d8391faae7e669b830526089df32b4"
  end

  def install
    bin.install "rx"
    %w[rxc rxx rxo rxp rxd rxk].each { |name| bin.install_symlink "rx" => name }
    generate_completions_from_executable(bin/"rx", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rx --version")
  end
end
