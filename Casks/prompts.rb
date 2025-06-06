cask "prompts" do
    version "0.1.1"
  
    if Hardware::CPU.arm?
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_aarch64.dmg"
      sha256 "7634439596857292b08300a6aab5468501973c7a764a9d402ad92d6cdcf872cb"
    else
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_x64.dmg"
      sha256 "e67fedbe6b284f6d748079b250889ba4b8049597200dfb6e298e9c50ef1d4501"
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
