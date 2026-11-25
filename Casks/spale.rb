cask "spale" do
  version "0.1.3"

  on_arm do
    sha256 "fd6a1ea8dd38630a976de3934c34c1b47afaeca86751a65cd91a14f99002617e"

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

  uninstall quit: "us.samzong.spale"

  zap trash: [
    "~/Library/Application Support/CrashReporter/spale_*.plist",
    "~/Library/Preferences/us.samzong.spale.plist",
    "~/Library/Saved Application State/us.samzong.spale.savedState",
  ]
end
