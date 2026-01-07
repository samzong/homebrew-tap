cask "github-notifier" do
  version "0.2.0"

  on_arm do
    sha256 "cbbe301a50c7c00da330e1559e3530ff034c31cd8b4572497e31a83c64e36a45"

    url "https://github.com/samzong/GitHubNotifier/releases/download/v#{version}/GitHubNotifier-arm64.dmg"
  end
  on_intel do
    sha256 "05c6847d233570829cbc46019288a6ea4da84c1d8cc48332f3906e5c92e4a96f"

    url "https://github.com/samzong/GitHubNotifier/releases/download/v#{version}/GitHubNotifier-x86_64.dmg"
  end

  name "GitHub Notifier"
  desc "A macOS menu bar app for GitHub notifications"
  homepage "https://github.com/samzong/GitHubNotifier"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "GitHubNotifier.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/GitHubNotifier.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/GitHubNotifier*",
    "~/Library/Application Support/GitHubNotifier",
    "~/Library/Caches/com.samzong.githubnotifier",
    "~/Library/Containers/com.samzong.githubnotifier",
    "~/Library/Group Containers/group.com.samzong.githubnotifier",
    "~/Library/HTTPStorages/com.samzong.githubnotifier",
    "~/Library/LaunchAgents/com.samzong.githubnotifier.plist",
    "~/Library/Logs/GitHubNotifier",
    "~/Library/Preferences/ByHost/com.samzong.githubnotifier.*.plist",
    "~/Library/Preferences/com.samzong.githubnotifier.plist",
    "~/Library/Saved Application State/com.samzong.githubnotifier.savedState",
    "~/Library/WebKit/com.samzong.githubnotifier",
  ]
end
