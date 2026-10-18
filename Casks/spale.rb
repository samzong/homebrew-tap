cask "spale" do
  version "0.1.0"

  on_arm do
    sha256 "d3ecd987f46c7c93729fb80caa99884ad740ff59f901a0ed67dc3ef1b61bb441"

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
