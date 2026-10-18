cask "spale" do
  version "0.1.1"

  on_arm do
    sha256 "ddcf9d46f417b8d267de057e2d840a25fd57edc4c1dcae5cfdddcca0bf55e61f"

    url "https://github.com/samzong/spale/releases/download/v#{version}/spale-v#{version}-macos-arm64.zip"
  end

  name "spale"
  desc "Native reader for live Git changes and plain-text editor"
  homepage "https://github.com/samzong/spale"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "spale.app"
  binary "#{appdir}/spale.app/Contents/MacOS/spale", target: "spale"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/spale.app"]
  end
end
