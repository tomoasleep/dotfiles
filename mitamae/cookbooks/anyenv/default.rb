git from_home(".anyenv") do
  repository "https://github.com/anyenv/anyenv"
end

execute "Initialize anyenv" do
  command "yes | ~/.anyenv/bin/anyenv install --init"
  not_if "test -d ~/.config/anyenv/anyenv-install"
end

define :anyenv_env, default_packages: nil, plugins: [] do
  name = params[:name]
  plugins = params[:plugins]
  default_packages = params[:default_packages]

  execute "Install #{name}" do
    command "~/.anyenv/bin/anyenv install #{name}"
    not_if "~/.anyenv/bin/anyenv version | grep '^#{name}'"
  end

  directory from_home(".anyenv/envs/#{name}/plugins") do
    action :create
    mode "0755"
  end

  plugins.each do |plugin|
    plugin_name = plugin.split("/").last
    git from_home(".anyenv/envs/#{name}/plugins/#{plugin_name}") do
      repository plugin
    end
  end

  if default_packages
    link from_home(".anyenv/envs/#{name}/#{default_packages}") do
      to File.expand_path("../../../../config/#{name}-#{default_packages}", __FILE__)
      user node[:user]
      force true
    end
  end
end

anyenv_env :rbenv do
  default_packages "default-gems"
  plugins([
    "https://github.com/rbenv/rbenv-default-gems",
    "https://github.com/rbenv/rbenv-each",
  ])
end

anyenv_env :nodenv do
  default_packages "default-packages"
  plugins([
    "https://github.com/nodenv/nodenv-package-rehash",
    "https://github.com/nodenv/nodenv-default-packages",
    "https://github.com/nodenv/nodenv-aliases",
  ])
end

directory from_home(".anyenv/plugins") do
  action :create
  mode "0755"
end

git from_home(".anyenv/plugins/anyenv-update") do
  repository "https://github.com/znz/anyenv-update"
end
