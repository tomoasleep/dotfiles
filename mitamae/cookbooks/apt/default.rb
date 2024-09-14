execute 'apt-get update -y' do
  user 'root'
  # https://askubuntu.com/questions/410247/how-to-know-last-time-apt-get-update-was-executed
  # https://stackoverflow.com/questions/5934394/subtract-1-hour-from-date-in-unix-shell-script
  not_if 'test -f /var/cache/apt/pkgcache.bin && test $(stat /var/cache/apt/pkgcache.bin --format="%Z") -gt $(date -d "1 hour ago" +%s)'
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
