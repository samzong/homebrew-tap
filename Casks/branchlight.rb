cask "branchlight" do
  version "0.5.5"

  on_arm do
    sha256 "ec082f11c59f6d216e1b9e1561ae9394280af70a1e87434295f83d01ef21164b"

    url "https://github.com/samzong/branchlight/releases/download/v#{version}/Branchlight-arm64.dmg"
  end
  on_intel do
    sha256 "4326b17c4fe38fdfe9898922e371b66aafa1ae5dc96af68dd25b31c98792e154"

    url "https://github.com/samzong/branchlight/releases/download/v#{version}/Branchlight-x86_64.dmg"
  end

  name "Branchlight"
  desc "Quiet menubar hub for GitHub work"
  homepage "https://github.com/samzong/branchlight"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Branchlight.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Branchlight.app"]
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
