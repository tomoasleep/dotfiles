execute "Make ensure aqua is installed" do
  command '/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.2/aqua-installer)"'
  not_if "which aqua"
end

execute "Install aqua packages" do
  command '/bin/bash -c "source ~/.bashrc.dotfiles && aqua install --all --only-link"'
end
