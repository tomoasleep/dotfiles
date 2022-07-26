include_role 'base'

dotconfig 'karabiner'
dotfile '.tmux.conf.osx'

include_cookbook 'homebrew'
include_cookbook 'devtools'

include_cookbook 'anyenv'

homebrew "1password"
homebrew "1password-cli"
homebrew "pam-reattach"
homebrew "alt-tab"
homebrew "atom"
homebrew "docker" do
  cask true
end
homebrew "google-japanese-ime"
homebrew "google-cloud-sdk"
homebrew "google-drive"
homebrew "hyper"
homebrew "iterm2"
homebrew "tailscale"
homebrew "karabiner-elements"
homebrew "keeweb"
homebrew "krisp"
homebrew "postman"
homebrew "ueli"
homebrew "sequel-pro"
homebrew "rectangle-pro"
homebrew "slack"
homebrew "spotify"
homebrew "visual-studio-code"
homebrew "xquartz"
homebrew "raycast"
homebrew "bartender"
homebrew "bing-wallpaper"
homebrew "microsoft-remote-desktop"

homebrew "homebrew/cask-drivers/logitech-options"
homebrew "homebrew/cask-drivers/logi-options-plus"

homebrew "homebrew/cask-fonts/font-hackgen"
homebrew "homebrew/cask-fonts/font-hackgen-nerd"
homebrew "homebrew/cask-fonts/font-ricty-diminished"
