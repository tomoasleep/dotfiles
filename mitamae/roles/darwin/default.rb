include_role 'base'

dotconfig 'karabiner'
dotfile '.tmux.conf.osx'

include_cookbook 'homebrew'
include_cookbook 'devtools-homebrew'

include_cookbook 'anyenv'

homebrew '1password'
homebrew '1password-cli'
homebrew 'pam-reattach'
homebrew 'alt-tab'
homebrew 'ankerwork'
homebrew 'atom'
homebrew 'docker' do
  cask true
end
homebrew 'google-japanese-ime'
homebrew 'google-cloud-sdk'
homebrew 'google-drive'
homebrew 'hyper'
homebrew 'iterm2'
homebrew 'jetbrains-toolbox'
homebrew 'tailscale'
homebrew 'karabiner-elements'
homebrew 'keeweb'
homebrew 'krisp'
homebrew 'postman'
homebrew 'ueli'
homebrew 'sequel-pro'
homebrew 'rectangle-pro'
homebrew 'slack'
homebrew 'spotify'
homebrew 'visual-studio-code'
homebrew 'xquartz'
homebrew 'raycast'
homebrew 'bartender'
# homebrew 'bing-wallpaper'
homebrew 'microsoft-remote-desktop'

homebrew 'wezterm'
homebrew 'logi-options-plus' do
  cask true
end

homebrew 'font-hackgen'
homebrew 'font-hackgen-nerd'
homebrew 'font-ricty-diminished'

homebrew 'd-kuro/tap/gwq'

