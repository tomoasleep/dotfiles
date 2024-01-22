include_role 'base'

include_cookbook 'apt-build-essentials'

case node.kernel.machine
when 'x86_64'
  include_cookbook 'homebrew'
  include_cookbook 'devtools-homebrew'
when 'arm64', 'aarch64'
  include_cookbook 'devtools-apt'
end

# https://github.com/microsoft/WSL/issues/4071
if File.read('/proc/version').include?('microsoft')
  include_cookbook 'wsl'
end

include_cookbook 'anyenv'
