class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.7.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "1a6e3795a5c2272d9e5ea9d0e9e19b7972e7c5c821683bdaf13dc53bf6d4accf"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "a44fc55688298196dbdae310a9bc33a61b7e63107549cac940e98b50a392485a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "d2b65f6d5b3e0f15533a08e85bdfcbf0caa1e41eb74916d88b13321ab0737b5a"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "cb6aa6c4e1662f95367f48e93dcf31a9df1f41adaa7cf9183351abd22735d9cd"
    end
  end

  def install
    bin.install "gmc"
    man1.install Dir["docs/man/*.1"]
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
