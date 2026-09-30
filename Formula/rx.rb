class Rx < Formula
  desc "Launch agent harnesses through a configured AI provider"
  homepage "https://github.com/samzong/rx"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-aarch64.tar.gz"
      sha256 "4ffd9f7a9bc9f5e3888313c9e5fb0770bba725ddb619edef29adf49002ae3e38"
    else
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-x86_64.tar.gz"
      sha256 "e6ce9a5b588200bc25034c93129e3f84b5a8a3bc3ed92be033a9ad354d432f57"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/samzong/rx/releases/download/v#{version}/rx-linux-x86_64.tar.gz"
    sha256 "eb91f86ed3ee11b876324c6d36ab2bf7d766a63ed41a490367d3c223f98dbc9c"
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
