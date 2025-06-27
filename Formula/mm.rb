class Mm < Formula
  desc "CLI for that help you fast to contribution to projects."
  homepage "https://github.com/samzong/mm"
  version "0.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_arm64.tar.gz"
      sha256 "e65bd09ec1be71e5a623d63986268b4ca7858532d6f461cac428c59e80191b96"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Darwin_x86_64.tar.gz"
      sha256 "a5062eac5c8dd74ab94b3c26627ba65474de83bdf95e8c121e4da69f5fe2a407"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_arm64.tar.gz"
      sha256 "239da37da5a0aaabe33fa0d135ae7391d8d3b01c14e122ffe5581702567f60db"
    else
      url "https://github.com/samzong/mm/releases/download/v#{version}/mm_Linux_x86_64.tar.gz"
      sha256 "6b2f48b4a9a188a8bef22af3e19822c47c57fc85f4dfd9719c84addf7d7e0138"
    end
  end

  def install
    bin.install "mm"
  end

  depends_on formula: ["gh"]

  test do
    system "#{bin}/mm", "--version"
  end
end
