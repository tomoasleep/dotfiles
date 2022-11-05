include_role 'base'

include_cookbook 'apt-build-essentials'

case node.kernel.machine
when 'x86_64'
  include_cookbook 'homebrew'
  include_cookbook 'devtools-homebrew'
when 'arm64', 'aarch64'
  include_cookbook 'devtools-apt'
end

include_cookbook 'anyenv'
