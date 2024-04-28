execute "Make ensure aqua is installed" do
  command '/bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.0/aqua-installer)"'
  not_if "which aqua"
end

execute "Install aqua packages" do
  command '/bin/bash -c "source ~/.bashrc.dotfiles && aqua install --all --only-link"'
end
