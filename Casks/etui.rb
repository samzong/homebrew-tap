cask "etui" do
  version "0.1.0"

  on_arm do
    sha256 "6d7f016da8721033c4b44415ac187d107e65e05997da8227e7b87106a842cb8a"

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
