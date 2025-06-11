cask "prompts" do
    version "0.1.7"
  
    if Hardware::CPU.arm?
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_aarch64.dmg"
      sha256 "16a6c5334b7682408b39fa1adb9d653b9ac7603e94410a49137d346dd382c41b"
    else
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_x64.dmg"
      sha256 "ebe89203821f07ac2d4d8ad6d8a3b5b699f3bcbaf96f3d03a56fc1c045e49fa3"
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
