# Configure dash to load ~/.profile before each command.
# See: https://manpages.ubuntu.com/manpages/trusty/man1/sh.1.html
ENV['ENV'] = File.join(ENV['HOME'], '.profile')
ENV['BASH_ENV'] = File.join(ENV['HOME'], '.profile')

node.reverse_merge!(
  os: run_command('uname').stdout.strip.downcase,
)

directory File.expand_path("~/.config") do
  action :create
end

path_from_dotfiles = -> (path) { dotfiles_path(path) }
devcontainer = devcontainer?

define :dotconfig, source: nil do
  source = params[:source] || params[:name]
  link File.join(ENV['HOME'], '.config', params[:name]) do
    to path_from_dotfiles.call("config/#{source}")
    user node[:user] unless devcontainer
    force true
  end
end

define :dotfile, source: nil do
  source = params[:source] || params[:name]
  link File.join(ENV['HOME'], params[:name]) do
    to path_from_dotfiles.call("config/#{source}")
    user node[:user] unless devcontainer
    force true
  end
end

define :lineinfile, line: nil do
  path = File.join(ENV['HOME'], params[:name])
  content = Shellwords.shellescape(params[:line])

  execute path do
    command "printf '%s\n' #{content} >> #{path}"
    not_if "grep -e #{content} #{path}"
  end
end

# define :github_binary, version: nil, repository: nil, archive: nil, binary_path: nil do
#   cmd = params[:name]
#   bin_path = "#{ENV['HOME']}/bin/#{cmd}"
#   archive = params[:archive]
#   url = "https://github.com/#{params[:repository]}/releases/download/#{params[:version]}/#{archive}"
#
#   if archive.end_with?('.zip')
#     extract = "unzip -o"
#   elsif archive.end_with?('.tar.gz')
#     extract = "tar xvzf"
#   else
#     raise "unexpected ext archive: #{archive}"
#   end
#
#   execute "curl -fSL -o /tmp/#{archive} #{url}" do
#     not_if "test -f #{bin_path}"
#   end
#   execute "#{extract} /tmp/#{archive}" do
#     not_if "test -f #{bin_path}"
#     cwd "/tmp"
#   end
#   execute "mv /tmp/#{params[:binary_path] || cmd} #{bin_path} && chmod +x #{bin_path}" do
#     not_if "test -f #{bin_path}"
#   end
# end
#
# define :user_service, action: [] do
#   name = params[:name]
#
#   Array(params[:action]).each do |action|
#     case action
#     when :enable
#       execute "sudo -E -u #{node[:user]} systemctl --user enable #{name}" do
#         not_if "sudo -E -u #{node[:user]} systemctl --user --quiet is-enabled #{name}"
#       end
#     when :start
#       execute "sudo -E -u #{node[:user]} systemctl --user start #{name}" do
#         not_if "sudo -E -u #{node[:user]} systemctl --user --quiet is-active #{name}"
#       end
#     end
#   end
# end
