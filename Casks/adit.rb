cask "adit" do
  version "0.2.0"

  on_arm do
    sha256 "7cd3269c3c71aff9309e095d6e57cff95802ec631f699c36b4c0928130e25698"

    url "https://github.com/samzong/adit/releases/download/v#{version}/Adit-#{version}-arm64.dmg"
  end

  name "Adit"
  desc "Local macOS shell for resumable LLM web conversation entrances"
  homepage "https://github.com/samzong/adit"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "Adit.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Adit.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/Adit*",
    "~/Library/Application Support/Adit",
    "~/Library/Caches/com.samzong.adit",
    "~/Library/HTTPStorages/com.samzong.adit",
    "~/Library/Logs/Adit",
    "~/Library/Preferences/ByHost/com.samzong.adit.*.plist",
    "~/Library/Preferences/com.samzong.adit.plist",
    "~/Library/Saved Application State/com.samzong.adit.savedState",
  ]
end
