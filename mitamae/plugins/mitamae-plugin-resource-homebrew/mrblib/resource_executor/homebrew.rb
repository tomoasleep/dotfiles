module ::MItamae
  module Plugin
    module ResourceExecutor
      class Homebrew < ::MItamae::ResourceExecutor::Base
        def apply
          if !current.exist && desired.exist
            run_command([homebrew_path, "install", *command_options, desired.target])
          end

          if current.exist && !desired.exist
            run_command([homebrew_path, "uninstall", desired.target])
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
          "#{homebrew_path} list -1 --full-name"
        end

        def homebrew_path
          if FileTest.file?("/opt/homebrew/bin/brew")
            "/opt/homebrew/bin/brew"
          elsif FileTest.file?("/home/linuxbrew/.linuxbrew/bin/brew")
            "/home/linuxbrew/.linuxbrew/bin/brew"
          else
            "brew"
          end
        end
      end
    end
  end
end
