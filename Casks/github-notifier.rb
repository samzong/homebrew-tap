cask "github-notifier" do
  version "0.0.0"

  on_arm do
    sha256 "255f01781031cd1d5979c51c517636773d30af2d4c4eee4ac46f277534fb41ae"

    url "https://github.com/samzong/GitHubNotifier/releases/download/v#{version}/GitHubNotifier-arm64.dmg"
  end
  on_intel do
    sha256 "6565e2a30bcc4f942df711eae8decc453eb06d957b5f334147330b643a0f39b2"

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
