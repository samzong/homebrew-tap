class Mdctl < Formula
  desc "A CLI tool for managing markdown files"
  homepage "https://github.com/samzong/mdctl"
  version "0.0.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_arm64.tar.gz"
      sha256 "dc9f4ae3a015420cfdd1c6cddc8a4e8010e57e9b7938db1a9d6c489ee78770e1"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Darwin_x86_64.tar.gz"
      sha256 "601df1af7060dedaae29aa823cfd791087d2e13a1f8cf1ffda0a23a877749985"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_arm64.tar.gz"
      sha256 "37656b73032e105ce883d5146fc8126b9933d7c2773f32702c485aff3abd92f3"
    else
      url "https://github.com/samzong/mdctl/releases/download/v#{version}/mdctl_Linux_x86_64.tar.gz"
      sha256 "2b905b5317c9b41f3d024715cba7550ef495d93fcb3adbe309b6807d20ccf310"
    end
  end

  def install
    bin.install "mdctl"
  end

  test do
    system "#{bin}/mdctl", "--version"
  end
end 