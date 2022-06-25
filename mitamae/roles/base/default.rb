include_cookbook 'functions'

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
