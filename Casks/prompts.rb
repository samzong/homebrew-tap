cask "prompts" do
  version "0.1.9"

  on_arm do
    sha256 "10a33fa660529dfff8edb00dd57ecb2b648dc70d5cfbf57e0faab2a32cb9e974"

    url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_aarch64.dmg"
  end
  on_intel do
    sha256 "9aba20db614b918df8c1c6a3dac57f512dc848ecc1590294106551ff8d2a390e"

    url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_x64.dmg"
  end

  name "Prompts"
  desc "System-level prompt management tool"
  homepage "https://github.com/samzong/prompts"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Prompts.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/Prompts.app"]
  end

  zap trash: [
    "/Library/Logs/DiagnosticReports/Prompts*",
    "~/Library/Application Support/com.samzong.prompts",
    "~/Library/Caches/com.samzong.prompts",
    "~/Library/Containers/com.samzong.prompts",
    "~/Library/Group Containers/group.com.samzong.prompts",
    "~/Library/HTTPStorages/com.samzong.prompts",
    "~/Library/LaunchAgents/com.samzong.prompts.plist",
    "~/Library/Logs/Prompts",
    "~/Library/Preferences/ByHost/com.samzong.prompts.*.plist",
    "~/Library/Preferences/com.samzong.prompts.plist",
    "~/Library/Saved Application State/com.samzong.prompts.savedState",
    "~/Library/WebKit/com.samzong.prompts",
  ]
end
