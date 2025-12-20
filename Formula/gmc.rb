class Gmc < Formula
  desc "CLI for that accelerates the efficiency of Git add and commit"
  homepage "https://github.com/samzong/gmc"
  version "0.4.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_arm64.tar.gz"
      sha256 "d33de40d14b1f43d659756d650d666cd3ee910b6e38b6e8494298862d6f07982"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Darwin_x86_64.tar.gz"
      sha256 "1b779e52fd3bd373f080f9d33e6b2879588a14ea93c585868e9430c0cddd6334"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_arm64.tar.gz"
      sha256 "fb59ec2e16ccfd06eb905682900f349fbb4bd869be42e119057059aef31a2ab0"
    else
      url "https://github.com/samzong/gmc/releases/download/v#{version}/gmc_Linux_x86_64.tar.gz"
      sha256 "2ff4cda43c8d9c480ccfa564665e568e2b39a2d2a39e0fdf0ceba59408b8d63d"
    end
  end

  def install
    bin.install "gmc"
  end

  test do
    system "#{bin}/gmc", "--version"
  end
end
