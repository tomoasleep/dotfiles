require 'optparse'
require 'yaml'
require 'json'

require_relative '../zellij_bundler'

module ZellijBundler
  class CLI
    COMMANDS = %w[bundle add install list remove update init config-template]

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
          add <repo>          Add plugin to zellij-bundles.rb and install
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
          zellij-bundler add leakec/multitask
          zellij-bundler install leakec/multitask
          zellij-bundler list
          zellij-bundler update all
      HELP
    end

    def execute_command(command, options)
      case command
      when 'bundle'
        handle_bundle(options)
      when 'add'
        handle_add(options)
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

    def find_dsl_file
      if File.exist?('zellij-bundles.rb')
        'zellij-bundles.rb'
      elsif File.exist?(File.join('..', 'zellij-bundles.rb'))
        File.join('..', 'zellij-bundles.rb')
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

        current = lockfile.find_by_repo(plugin.repo)
        if current && tags_match?(current, plugin.tag) && file_exists?(plugin, current, dsl.config)
          puts '   ⏭️  Already installed'
          puts ''
          next
        elsif current && tags_match?(current, plugin.tag) && !file_exists?(plugin, current, dsl.config)
          puts '   ⚠️  File missing, downloading...'
        end

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

    def handle_add(options)
      repo = options[:args].first

      unless repo
        puts '❌ Error: Repository required'
        puts '   Usage: zellij-bundler add <owner/repo>'
        exit 1
      end

      puts "ℹ️  Checking for WASM files in #{repo}..."

      unless Installer.check_wasm_available(repo)
        puts "⚠️  No WASM files found in releases for #{repo}"
        puts '   Cannot add this plugin'
        exit 1
      end

      puts "✅ Found WASM files in #{repo}"
      puts ''

      dsl_file = 'zellij-bundles.rb'

      unless File.exist?(dsl_file)
        puts "❌ Error: #{dsl_file} not found"
        puts "   Run 'zellij-bundler init' to create a new #{dsl_file}"
        exit 1
      end

      plugin_line = "plugin '#{repo}'"

      File.open(dsl_file, 'a') do |file|
        file.puts plugin_line
      end

      puts "✅ Added '#{repo}' to #{dsl_file}"
      puts ''
      puts '📦 Bundling plugins...'

      handle_bundle(options)
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
        if current
          if file_exists?(plugin, current, dsl.config) && up_to_date_with_latest?(current, plugin)
            puts '   ⏭️  Already up to date'
            puts ''
            next
          elsif !file_exists?(plugin, current, dsl.config)
            puts '   ⚠️  File missing, downloading...'
          end
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
      lines << '// Zellij Plugin Configuration'
      lines << '// Generated by zellij-bundler'
      lines << ''
      lines << 'plugins {'
      lines << '  // Add your plugins below'

      plugins.each do |plugin|
        filename = plugin['file']
        path = File.join(output_dir, filename)
        alias_name = filename.sub('.wasm', '').gsub('_', '-')
        lines << "  #{alias_name} location=\"file:#{path}\""
      end

      lines << '}'

      puts lines.join("\n")
    end

    def file_exists?(plugin, lockfile_entry, dsl_config)
      output_dir = plugin.output_dir || dsl_config[:output_dir] || './plugins'
      output_dir = File.expand_path(output_dir)
      filepath = File.join(output_dir, lockfile_entry['file'])
      File.exist?(filepath)
    end

    def tags_match?(lockfile_entry, plugin_tag)
      plugin_tag.nil? || lockfile_entry['tag'] == plugin_tag
    end

    def up_to_date_with_latest?(lockfile_entry, plugin)
      latest_tag = fetch_latest_tag(plugin.repo, plugin.tag)
      latest_tag && lockfile_entry['tag'] == latest_tag
    end

    def fetch_latest_tag(repo, specified_tag)
      return specified_tag if specified_tag

      cmd = "gh release view -R #{repo} --json tagName"
      json = `#{cmd}`
      return nil unless $?.success?

      data = JSON.parse(json)
      data['tagName']
    rescue StandardError
      nil
    end
  end
end
