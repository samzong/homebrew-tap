class Rx < Formula
  desc "Launch agent harnesses through a configured AI provider"
  homepage "https://github.com/samzong/rx"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-aarch64.tar.gz"
      sha256 "b3fd4886343a8b463c81f2e85aa5daebf282ed40a7363d975d1796d24c14c69e"
    else
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-x86_64.tar.gz"
      sha256 "7d49c7e722f71a5762573d419502ed60a2c2e4bb23be91c9e5e241db47b395ee"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/samzong/rx/releases/download/v#{version}/rx-linux-x86_64.tar.gz"
    sha256 "d3d525c80dfc58ea6277edb1a26cb2eb36d5acd74bbc659f5b25ef00aeda145f"
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
