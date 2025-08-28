class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "78abb2d179a7e2dd1856ec0ba7825957815472557e49932a0cfc70a646fbaec8"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "349ace94441cea93c8a94c686d55b795fe4a1f58c220fd40d9fdf55891e14d3f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "74ca898f7d0234064a39414ae1102d4ccb7806de8f2b3acb6b63be6b332efdbc"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "3d3eae3d8be526e54f3b80eec926f0ce1b49562f1227e5fc6492e674632cc3e8"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
