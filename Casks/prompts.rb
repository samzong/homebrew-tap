cask "prompts" do
    version "0.1.4"
  
    if Hardware::CPU.arm?
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_aarch64.dmg"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    else
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_x64.dmg"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
