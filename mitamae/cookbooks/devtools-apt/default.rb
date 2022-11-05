include_cookbook 'apt'
include_cookbook 'anyenv'
include_cookbook 'asdf'

apt 'tig'
apt 'wget'

# https://launchpad.net/~fish-shell/+archive/ubuntu/release-3
apt_repository 'ppa:fish-shell/release-3'
apt 'fish'

asdf_plugin 'direnv' do
  install_latest true
end

# For now, deno for linux arm64 is not provided.
# asdf_plugin 'deno' do
#   install_latest true
# end

asdf_plugin 'fzf' do
  install_latest true
end

asdf_plugin 'ghq' do
  url 'https://github.com/tomoasleep/asdf-ghq'
  install_latest true
end

asdf_plugin 'github-cli' do
  url 'https://github.com/tomoasleep/asdf-github-cli'
  install_latest true
end

asdf_plugin 'golang' do
  install_latest true
end

asdf_plugin 'jq' do
  install_latest true
end

asdf_plugin 'neovim' do
  install_latest true
end

asdf_plugin 'python' do
  install_latest true
end

asdf_plugin 'rust' do
  install_latest true
end

asdf_plugin 'tmux' do
  install_latest true
end

asdf_plugin 'yarn' do
  install_latest true
end

# ansible-base requires direnv and pip
asdf_plugin 'ansible-base' do
  install_latest true
end
