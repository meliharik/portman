cask "portman" do
  version "0.1.0"
  sha256 "79fe9066335bc713718cd2f91bd021609b413580f0d72c9276e5ddcf0ac0e885"

  url "https://github.com/meliharik/portman/releases/download/v#{version}/portman-#{version}.dmg"
  name "portman"
  desc "Menu bar app to view and terminate processes listening on TCP ports"
  homepage "https://github.com/meliharik/portman"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sequoia"

  app "portman.app"

  zap trash: [
    "~/Library/Application Support/dev.meliharik.portman",
    "~/Library/Caches/dev.meliharik.portman",
    "~/Library/Preferences/dev.meliharik.portman.plist",
  ]
end
