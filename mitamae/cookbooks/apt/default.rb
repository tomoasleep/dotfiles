execute "apt-get update -y" do
  user "root"
end

define :apt do
  package params[:name] do
    action :install
    user "root"
  end
end
