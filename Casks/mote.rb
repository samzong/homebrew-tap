cask "mote" do
  version "0.1.0"

  on_arm do
    sha256 "2807ddc8a8a3f3168cf9e4c06ce5ccde46cebd91b47ff0e36c79a1a8501c3a58"

    url "https://github.com/samzong/mote/releases/download/v#{version}/Mote-arm64.dmg"
  end

  name "Mote"
  desc "Menu bar app for rewriting selected text with OpenAI-compatible models"
  homepage "https://github.com/samzong/mote"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Mote.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Mote.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/Mote*",
    "~/.config/mote",
    "~/Library/Application Support/Mote",
    "~/Library/Caches/com.samzong.mote",
    "~/Library/HTTPStorages/com.samzong.mote",
    "~/Library/Logs/Mote",
    "~/Library/Preferences/ByHost/com.samzong.mote.*.plist",
    "~/Library/Preferences/com.samzong.mote.plist",
    "~/Library/Saved Application State/com.samzong.mote.savedState",
  ]
end
