include_cookbook 'functions'

repo_root = File.expand_path("../../../../", __FILE__)

link File.join(ENV['HOME'], 'dotfiles') do
  to repo_root
  user node[:user]
  force true
end

dotconfig 'nvim'
dotconfig 'nyaovim'
dotconfig 'fish'
dotconfig 'git'

dotfile '.atom'
dotfile '.bashrc.dotfiles'
dotfile '.profile.dotfiles'
dotfile '.gitconfig'
dotfile '.tmux'
dotfile '.tmux.conf'
dotfile '.tigrc'
dotfile '.hyper.js'

lineinfile '.bashrc' do
  line "test -f ~/.bashrc.dotfiles && source ~/.bashrc.dotfiles"
end

lineinfile '.profile' do
  line "test -f ~/.profile.dotfiles && source ~/.profile.dotfiles"
end
