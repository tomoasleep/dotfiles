module ::MItamae
  module Plugin
    module ResourceExecutor
      class Homebrew < ::MItamae::ResourceExecutor::Base
        def apply
          if !current.exist && desired.exist
            run_command(["brew", "install", *command_options, desired.target])
          end

          if current.exist && !desired.exist
            run_command(["brew", "uninstall", desired.target])
          end
        end

        private

        def command_options
          options = Array(desired.options)
          options << "--cask" if desired.cask

          options
        end

        def set_current_attributes(current, action)
          result = run_command("#{brew_list} | grep -E '(^|/)#{desired.target}(@|$)'", error: false)
          current.exist = (result.exit_status == 0)
        end

        def set_desired_attributes(desired, action)
          case action
          when :install
            desired.exist = true
          when :uninstall
            desired.exist = false
          end
        end

        def brew_list
          "brew list -1 --full-name"
        end
      end
    end
  end
end
