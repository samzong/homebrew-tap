cask "etui" do
  version "0.1.1"

  on_arm do
    sha256 "8f5e6986f6ca350ea823a775ebd445cb414f208e905b6ff11234ca4d6fe2b184"

    url "https://github.com/samzong/Etui/releases/download/v#{version}/Etui-#{version}-arm64.dmg"
  end

  name "Etui"
  desc "Launcher, clipboard manager, and window tiling utility"
  homepage "https://github.com/samzong/Etui"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Etui.app"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Etui.app"]
  end
end
