class Mm < Formula
  desc "CLI for that help you fast to contribution to projects"
  homepage "https://github.com/samzong/mm"
  version "0.0.5"

  depends_on "gh"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_arm64.tar.gz"
      sha256 "f8f5106edd248e43968759b7c1bc3f88b551e6f25f1a19d823059fdf1f93ad7e"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_x86_64.tar.gz"
      sha256 "370a4a89c02324bb7364484352ef447db75d7b5f40b490a1bc885784d9be4f1d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_arm64.tar.gz"
      sha256 "cd30fcca900dfce4dbcfaa766a913ada981189da1e9a0f9fe6418a54ab511e9f"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_x86_64.tar.gz"
      sha256 "cc54ba953c19c9b06e500849d38aa7f6ecde88a884b82483d714aea769f1c2bd"
    end
  end

  def install
    bin.install "mm"
  end

  test do
    system "#{bin}/mm", "--version"
  end
end
