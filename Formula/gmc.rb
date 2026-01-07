class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.6.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "48854ec80e84b3375e6dc3ea1389a87f14f9b735063416ef07f8ce10f51ed065"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "08535edf6f03af741a8936272fb74c714f808a65664b50247f7ebbd199bcb3a0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "d8d38283c1cafc89c19a7fb4a42545298153c1ae920275f13bc42cc0d6c2f2ff"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "3cfeeedbff22fd6d8bc17727c9fd38f38e08e21d8bb6cbf9a1163cec3c973e29"
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
