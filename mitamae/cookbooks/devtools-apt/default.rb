include_cookbook 'apt'
include_cookbook 'anyenv'
include_cookbook 'asdf'

apt 'tig'
apt 'wget'

# For now, deno for linux arm64 is not provided.
# asdf_plugin 'deno' do
#   install_latest true
# end

asdf_plugin 'tmux' do
  install_latest true
end

unless devcontainer?
  asdf_plugin 'golang' do
    install_latest true
  end

  asdf_plugin 'python' do
    install_latest true
  end

  asdf_plugin 'rust' do
    install_latest true
  end

  # ansible-base requires direnv and pip
  asdf_plugin 'ansible-base' do
    install_latest true
  end
end
