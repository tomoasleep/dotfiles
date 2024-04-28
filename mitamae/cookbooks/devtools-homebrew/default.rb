include_cookbook 'homebrew'

homebrew 'git'
homebrew 'grep'
homebrew 'tig'
homebrew 'tmux'
homebrew 'wget'
homebrew 'zsh'

unless devcontainer?
  homebrew 'cmake'
  homebrew 'mysql'
  homebrew 'postgresql'
  homebrew 'ansible'
  homebrew 'pkg-config'
  homebrew 'icu4c'
  homebrew 'yarn'
end

include_cookbook 'anyenv'
include_cookbook 'asdf'
