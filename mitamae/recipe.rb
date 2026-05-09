include_recipe 'recipe_helper'

node.reverse_merge!(
  user: ENV['SUDO_USER'] || ENV['USER']
)

module ::Specinfra
  module Helper
    class DetectOs
      class Termux < ::Specinfra::Helper::DetectOs
        def detect
          if (termux_info = run_command('termux-info')) && termux_info.success?
            distro = 'termux'
            release = nil
            { family: distro, release: release }
          end
        end
      end
    end
  end
end

class ::Specinfra::Command::Termux < ::Specinfra::Command::Debian; end

if node['platform']
  include_role node['platform']
elsif (termux_info = run_command('termux-info')) && termux_info.success?
  class ::Specinfra::Backend::Base
    def os_info
      arch = run_command('uname -m').stdout.strip
      { family: 'termux', release: nil, arch: arch }
    end
  end


  include_role 'termux'
else
  puts 'unsupported OS'
end

