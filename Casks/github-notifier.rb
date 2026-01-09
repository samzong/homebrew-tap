cask "github-notifier" do
  version "0.4.3"

  on_arm do
    sha256 "09be9a79c33c14ca8c02ed5a081fed51c23490610486d4a8344557bd0fe8f369"

    url "https://github.com/samzong/GitHubNotifier/releases/download/v#{version}/GitHubNotifier-arm64.dmg"
  end
  on_intel do
    sha256 "9331629358b3981e7987e04edc81cdddd5702dec60a439c92cf84cf5910463c9"

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
