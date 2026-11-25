cask "etui" do
  version "0.2.0"

  on_arm do
    sha256 "1486582c30597942f574065b477a85cdada5a3a7a34ea11c1a414a225d669e87"

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
