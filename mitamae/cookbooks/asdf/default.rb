git from_home('.asdf') do
  repository 'https://github.com/asdf-vm/asdf'
  revision 'master'
end

define :asdf_plugin, install_latest: false, url: nil do
  name = params[:name]
  url = params[:url]
  install_latest = params[:install_latest]

  execute "Install #{name} plugin" do
    command url ? "~/.asdf/bin/asdf plugin add #{name} #{url}" : "~/.asdf/bin/asdf plugin add #{name}"
    not_if "~/.asdf/bin/asdf plugin list | grep '^#{name}'"
    notifies :run, "execute[Install #{name} plugin]"
  end

  if install_latest
    asdf_version name do
      action :nothing
      version 'latest'
      set_global true
      subscribes :run, "execute[Install #{name} plugin]"
    end
  end
end

define :asdf_version, version: 'latest', set_global: false do
  name = params[:name]
  version = params[:version]
  set_global = params[:set_global]

  execute "Install #{version} version of #{name} plugin" do
    command "~/.asdf/bin/asdf install #{name} #{version}"
    not_if "~/.asdf/bin/asdf list #{name} | grep #{version == 'latest' ? "$(~/.asdf/bin/asdf latest #{name})" : "'^#{version}$'"}"
  end

  if set_global
    file File.join(ENV['HOME'], '.tool-versions') do
      action :create
    end

    execute "Make #{version} version of #{name} plugin global" do
      command "~/.asdf/bin/asdf global #{name} #{version}"
    end
  end
end
