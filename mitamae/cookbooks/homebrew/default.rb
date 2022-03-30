execute "Make ensure homebrew is installed" do
  command 'NONINTERACTIVE=t /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  not_if "which brew"
end
