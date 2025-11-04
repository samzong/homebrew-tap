class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.1.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "1bd2d9938ff039578f50c49e82332a46a1fa371763ca7371984b91a491d073c1"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "388e3daa166a9cfa8101cd16ab2f4ac79698b33ba03d311b6da6674c0f10776a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "4fa984c4d25b5bdb1fc6c67d0849c2cf92044b9596367bad530c326b765a9f8f"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "834dec84297b2ee2b5e7281fa9af4f937210e9093c5dd5067b715e7f58ae8d37"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
