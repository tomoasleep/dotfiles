require 'optparse'
require 'json'
require 'fileutils'
require 'time'

require_relative 'zellij_bundler/version'

module ZellijBundler
end

require_relative 'zellij_bundler/plugin'
require_relative 'zellij_bundler/detector'
require_relative 'zellij_bundler/installer'
require_relative 'zellij_bundler/dsl'
require_relative 'zellij_bundler/lockfile'
require_relative 'zellij_bundler/config_template'
require_relative 'zellij_bundler/cli'
