module ::MItamae
  module Plugin
    module Resource
      class Homebrew < ::MItamae::Resource::Base
        define_attribute :action, default: :install
        define_attribute :target, type: String, default_name: true
        define_attribute :options, type: [String, Array], default: []

        self.available_actions = [:install, :uninstall]
      end
    end
  end
end
