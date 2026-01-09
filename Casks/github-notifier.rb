cask "github-notifier" do
  version "0.4.2"

  on_arm do
    sha256 "654d69846127349d335db92634862045ec5ea0506f21fbed717b9b2ba82070be"

    url "https://github.com/samzong/GitHubNotifier/releases/download/v#{version}/GitHubNotifier-arm64.dmg"
  end
  on_intel do
    sha256 "634ffa43760c64a2412e067c07ff8abde8c1b03beb21fcdba43d38359e2f325d"

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
