cask "mailbell" do
  version "0.0.2"

  on_arm do
    sha256 "c2908df0811f39973ba6874974f5020db1308486afd8fb4715ece5d6b24326f0"

    url "https://github.com/samzong/mailbell/releases/download/v#{version}/Mailbell-arm64.dmg"
  end

  name "Mailbell"
  desc "Menu bar Gmail notifier"
  homepage "https://github.com/samzong/mailbell"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "Mailbell.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Mailbell.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/Mailbell*",
    "~/Library/Application Support/Mailbell",
    "~/Library/Caches/com.samzong.mailbell",
    "~/Library/HTTPStorages/com.samzong.mailbell",
    "~/Library/Logs/Mailbell",
    "~/Library/Preferences/ByHost/com.samzong.mailbell.*.plist",
    "~/Library/Preferences/com.samzong.mailbell.plist",
    "~/Library/Saved Application State/com.samzong.mailbell.savedState",
  ]
end
