require 'optparse'
require 'yaml'

require_relative '../zellij_bundler'

module ZellijBundler
  class CLI
    COMMANDS = %w[bundle install list remove update init config-template]

    def self.run
      new.run(ARGV)
    end

    def run(args)
      options = parse_options(args)

      if options[:help]
        show_help
        return
      end

      command = options[:command]

      unless command
        show_help
        return
      end

      unless COMMANDS.include?(command)
        puts "Unknown command: #{command}"
        show_help
        exit 1
      end

      execute_command(command, options)
    rescue StandardError => e
      puts "Error: #{e.message}"
      exit 1
    end

    private

    def parse_options(args)
      options = { command: nil, help: false }

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: zellij-bundler [command] [options]'

        opts.on('-h', '--help', 'Show this help message') do
          options[:help] = true
        end
      end

      remaining_args = parser.parse(args)
      options[:command] = remaining_args.shift
      options[:args] = remaining_args

      options
    end

    def show_help
      puts <<~HELP
        Zellij Bundler - Manage Zellij plugins from GitHub releases

        Usage: zellij-bundler [command] [options]

        Commands:
          bundle              Install/update all plugins from zellij-bundles.rb
          install <repo>      Install a plugin from GitHub repository
          list                List installed plugins
          remove <plugin>     Remove a plugin
          update <plugin>     Update a plugin (or 'all' for all)
          init                Create a new zellij-bundles.rb file
          config-template      Print Zellij config template

        Options:
          -h, --help          Show this help message

        Examples:
          zellij-bundler bundle
          zellij-bundler install leakec/multitask
          zellij-bundler list
          zellij-bundler update all
      HELP
    end

    def execute_command(command, options)
      case command
      when 'bundle'
        handle_bundle(options)
      when 'install'
        handle_install(options)
      when 'list'
        handle_list(options)
      when 'remove'
        handle_remove(options)
      when 'update'
        handle_update(options)
      when 'init'
        handle_init(options)
      when 'config-template'
        handle_config_template(options)
      end
    end

    def handle_bundle(_options)
      dsl_file = 'zellij-bundles.rb'

      unless File.exist?(dsl_file)
        puts "❌ Error: #{dsl_file} not found"
        puts "   Run 'zellij-bundler init' to create a new #{dsl_file}"
        exit 1
      end

      dsl = Dsl.evaluate(dsl_file)
      lockfile = Lockfile.load

      puts "📦 Installing #{dsl.plugins.size} plugins..."
      puts ''

      installed = []

      dsl.plugins.each_with_index do |plugin, index|
        puts "[#{index + 1}/#{dsl.plugins.size}] #{plugin.repo}"

        result = Installer.install(plugin, dsl.config)
        if result
          lockfile.add_or_update(result)
          installed << result
        end

        puts ''
      end

      lockfile.save

      if installed.empty?
        puts '⚠️  No plugins were installed'
      else
        puts "✅ #{installed.size} plugin(s) installed/updated successfully!"
        puts ''
        puts "💡 Run 'zellij-bundler config-template' to see the Zellij configuration"
      end
    end

    def handle_install(options)
      repo = options[:args].first

      unless repo
        puts '❌ Error: Repository required'
        puts '   Usage: zellij-bundler install <owner/repo>'
        exit 1
      end

      plugin = Plugin.new(repo)
      lockfile = Lockfile.load

      result = Installer.install(plugin, {})

      return unless result

      lockfile.add_or_update(result)
      lockfile.save
    end

    def handle_list(_options)
      lockfile = Lockfile.load
      plugins = lockfile.all

      if plugins.empty?
        puts '📭 No plugins installed yet'
        puts ''
        puts "💡 Run 'zellij-bundler install <repo>' to install a plugin"
        return
      end

      puts '📦 Installed plugins:'
      puts ''

      plugins.each do |plugin|
        puts "   #{plugin['repo']}"
        puts "     Tag: #{plugin['tag']}"
        puts "     File: #{plugin['file']}"
        puts "     Size: #{format_size(plugin['size'])}"
        puts "     Downloaded: #{plugin['download_at'] || plugin['downloaded_at']}"
        puts ''
      end
    end

    def handle_remove(options)
      repo = options[:args].first

      unless repo
        puts '❌ Error: Repository required'
        puts '   Usage: zellij-bundler remove <owner/repo>'
        exit 1
      end

      lockfile = Lockfile.load
      plugin = lockfile.find_by_repo(repo)

      unless plugin
        puts "❌ Error: Plugin not found: #{repo}"
        exit 1
      end

      lockfile.remove(repo)
      lockfile.save

      output_dir = plugin[:output] || './plugins'
      filename = plugin['file']
      filepath = File.join(output_dir, filename)

      if File.exist?(filepath)
        File.delete(filepath)
        puts "✅ Removed: #{filename}"
      end

      puts "✅ Removed plugin: #{repo}"
    end

    def handle_update(options)
      target = options[:args].first || 'all'

      dsl_file = 'zellij-bundles.rb'

      unless File.exist?(dsl_file)
        puts "❌ Error: #{dsl_file} not found"
        exit 1
      end

      dsl = Dsl.evaluate(dsl_file)
      lockfile = Lockfile.load

      plugins_to_update = if target == 'all'
                            dsl.plugins
                          else
                            dsl.plugins.select { |p| p.repo == target }
                          end

      if plugins_to_update.empty?
        puts "❌ Error: Plugin not found: #{target}"
        exit 1
      end

      puts "🔄 Updating #{plugins_to_update.size} plugin(s)..."
      puts ''

      updated = []

      plugins_to_update.each_with_index do |plugin, index|
        puts "[#{index + 1}/#{plugins_to_update.size}] #{plugin.repo}"

        current = lockfile.find_by_repo(plugin.repo)
        if current && current['tag'] == plugin.tag
          puts '   ⏭️  Already up to date'
          puts ''
          next
        end

        result = Installer.install(plugin, dsl.config)
        if result
          lockfile.add_or_update(result)
          updated << result
        end

        puts ''
      end

      lockfile.save

      if updated.empty?
        puts '✅ All plugins are up to date'
      else
        puts "✅ #{updated.size} plugin(s) updated!"
      end
    end

    def handle_init(_options)
      dsl_file = 'zellij-bundles.rb'

      if File.exist?(dsl_file)
        puts "❌ Error: #{dsl_file} already exists"
        exit 1
      end

      content = <<~DSL
        # Zellij Bundler Configuration
        # Define your Zellij plugins here

        # Global settings
        set :output_dir, "./plugins"
        set :force, false

        # Plugins
        # plugin "leakec/multitask"
        # plugin "ndavd/zellij-cb"

        # Example with version
        # plugin "cunialino/zellij-sessionizer", tag: "v0.1.1"

        # Example with custom output and filename
        # plugin "owner/repo", to: "~/.zellij/plugins"
        # plugin "owner/repo", as: "custom-name.wasm"

        # Example with block syntax
        # plugin "owner/repo" do
        #   tag "v1.0.0"
        #   to "./custom/path"
        #   as "custom-name.wasm"
        # end
      DSL

      File.write(dsl_file, content)
      puts "✅ Created #{dsl_file}"
      puts ''
      puts "💡 Edit #{dsl_file} to add plugins, then run 'zellij-bundler bundle'"
    end

    def handle_config_template(_options)
      lockfile = Lockfile.load
      plugins = lockfile.all

      if plugins.empty?
        puts '📭 No plugins installed yet'
        puts ''
        puts "💡 Run 'zellij-bundler install <repo>' to install a plugin"
        return
      end

      output_dir = './plugins'
      lines = []
      lines << '# Zellij Plugin Configuration'
      lines << '# Generated by zellij-bundler'
      lines << ''
      lines << 'default_layout "default"'
      lines << ''
      lines << 'plugins:'
      lines << '  # Add your plugins below'

      plugins.each do |plugin|
        filename = plugin['file']
        path = File.join(output_dir, filename)
        lines << "  - location: \"file:#{path}\""
      end

      puts lines.join("\n")
    end

    def format_size(bytes)
      return '0 B' if bytes.nil? || bytes.zero?

      units = %w[B KB MB GB TB]
      exp = Math.log(bytes, 1024).floor
      exp = units.size - 1 if exp >= units.size
      "#{format('%.2f', bytes / (1024.0**exp))} #{units[exp]}"
    end
  end
end
