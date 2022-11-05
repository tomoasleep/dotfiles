execute 'apt-get update -y' do
  user 'root'
end

define :apt do
  package params[:name] do
    action :install
    user 'root'
  end
end

define :apt_repository do
  name = params[:name]

  execute "add-apt-repository -y #{name}" do
    notifies :run, "execute[add-apt-repository -y #{name}]"
    not_if "apt-add-repository --list | grep '#{name.delete_prefix('ppa:')}'"
    user 'root'
  end

  execute 'apt-get update -y' do
    action :nothing
    subscribes :run, "execute[add-apt-repository -y #{name}]"
    user 'root'
  end
end
