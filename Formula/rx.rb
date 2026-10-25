class Rx < Formula
  desc "Launch agent harnesses through a configured AI provider"
  homepage "https://github.com/samzong/rx"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-aarch64.tar.gz"
      sha256 "6da53564b3c371b96e703e712c31aac0183cf98ef2f823f95570f0bf9b17ac5b"
    else
      url "https://github.com/samzong/rx/releases/download/v#{version}/rx-macos-x86_64.tar.gz"
      sha256 "8fdc94200b5192a644d191d1e8ac1216ff86aad47f8ee00c2ca983c492630f2d"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/samzong/rx/releases/download/v#{version}/rx-linux-x86_64.tar.gz"
    sha256 "cf788577c1a811d3563224beed693db21b9146c02292351760d9f2626c4443d5"
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
