cask "spale" do
  version "0.1.2"

  on_arm do
    sha256 "5fa93058f71069525a12b71d47572711075f513dbc493a3dd32df095222a857d"

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
