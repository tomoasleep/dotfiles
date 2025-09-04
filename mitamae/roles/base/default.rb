include_cookbook 'functions'

repo_root = File.expand_path('../../..', File.dirname(__FILE__))

unless devcontainer?
  link File.join(ENV['HOME'], 'dotfiles') do
    to repo_root
    user node[:user]
    force true
  end
end

dotconfig 'aquaproj-aqua'
dotconfig 'nvim'
dotconfig 'nyaovim'
dotconfig 'fish'
dotconfig 'git'
dotconfig 'zed'
dotconfig 'zsh'
dotconfig 'starship.toml'
dotconfig 'karabiner.edn'
dotconfig 'ghostty'

dotfile '.atom'
dotfile '.asdfrc'
dotfile '.bashrc.dotfiles'
dotfile '.claude'
dotfile '.profile.dotfiles'
dotfile '.gitconfig'
dotfile '.tmux'
dotfile '.tmux.conf'
dotfile '.tigrc'
dotfile '.hyper.js'
dotfile '.wezterm.lua'
dotfile '.zshrc'

lineinfile '.bashrc' do
  line 'test -f ~/.bashrc.dotfiles && source ~/.bashrc.dotfiles'
end

lineinfile '.profile' do
  line 'test -f ~/.profile.dotfiles && source ~/.profile.dotfiles'
end

include_cookbook 'aqua'
