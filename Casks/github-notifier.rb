cask "github-notifier" do
  version "0.1.0"

  on_arm do
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"

    url "https://github.com/samzong/GitHubNotifier/releases/download/v#{version}/GitHubNotifier-arm64.dmg"
  end
  on_intel do
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"

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
