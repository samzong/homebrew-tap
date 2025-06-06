cask "prompts" do
    version "0.1.0"
  
    if Hardware::CPU.arm?
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_aarch64.dmg"
      sha256 "c3cc63551e3e94f6f5f88c3ed2e96877eb8e8fcf02dc3115a27953f707aba35e"
    else
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_x64.dmg"
      sha256 "42ca2db4726e6348767f2bba89f775a54379a26eabf699a3e5a34a3c2bac1c71"
    end
  
    name "Prompts"
    desc "System-level prompt management tool for macOS"
    homepage "https://github.com/samzong/prompts"
  
    livecheck do
      url :url
      strategy :github_latest
    end
  
    app "Prompts.app"
  
    zap trash: [
      "~/Library/Application Support/com.samzong.prompts",
      "~/Library/Caches/com.samzong.prompts",
      "~/Library/Preferences/com.samzong.prompts.plist",
      "~/Library/WebKit/com.samzong.prompts",
    ]
  end
