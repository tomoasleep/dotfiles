define :apt do
  package params[:name] do
    action :install
    user "root"
  end
end
