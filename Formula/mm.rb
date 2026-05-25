class Mm < Formula
  desc "CLI for that help you fast to contribution to projects"
  homepage "https://github.com/samzong/mm"
  version "0.0.6"

  depends_on "gh"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_arm64.tar.gz"
      sha256 "80f3234b3ab53e579a73c7541c0276f6ea4019d2618afdcde433e341a7a8cb6e"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_x86_64.tar.gz"
      sha256 "127c0d528457b02a722aa65b4eccbe743f13af696b4913aefb53d97f873ffb30"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_arm64.tar.gz"
      sha256 "01a14281eb5a3adb25e7df2ffcffebfe28d3421ac50f0495985432e6dc98cd01"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_x86_64.tar.gz"
      sha256 "81583bd2b66b1c2019deab1a307f0c6e8c0df27bc6cd9244bec953f1ec5a3a0f"
    end
  end

  def install
    bin.install "mm"
  end

  test do
    system "#{bin}/mm", "--version"
  end
end
