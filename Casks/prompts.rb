cask "prompts" do
    version "0.1.5"
  
    if Hardware::CPU.arm?
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_aarch64.dmg"
      sha256 "cbed1660698bf601c8e1d48d395f01b267fea6073b0d5080eeca769f6ca91927"
    else
      url "https://github.com/samzong/prompts/releases/download/v#{version}/Prompts_#{version}_x64.dmg"
      sha256 "a830201c164c5a191fc96800da6e01ba65b76f483f4ef9ee5d1eff8222484e69"
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
