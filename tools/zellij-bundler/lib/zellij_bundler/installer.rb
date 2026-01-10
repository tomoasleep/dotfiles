module ZellijBundler
  class Installer
    def self.install(plugin, global_config = {})
      new(plugin, global_config).install
    end

    def self.check_wasm_available(repo)
      cmd = "gh release view -R #{repo} --json tagName,assets"
      json = `#{cmd}`
      return false unless $?.success?

      release_info = JSON.parse(json)
      repo.split('/').last
      assets = release_info['assets'].map { |a| a['name'] }
      wasm_files = assets.select { |name| name.end_with?('.wasm') }

      !wasm_files.empty?
    rescue StandardError
      false
    end

    def initialize(plugin, global_config)
      @plugin = plugin
      @global_config = global_config
      @repo = plugin.repo
    end

    def install
      puts "ℹ️  Checking releases for #{@repo}..."

      release_info = fetch_release_info
      puts "ℹ️  Latest release: #{release_info['tagName']}"

      repo_name = extract_repo_name(@repo)
      detection = Detector.detect_wasm_file(repo_name, release_info['assets'], @plugin.filename)

      case detection[:status]
      when :found
        install_wasm_file(release_info, detection[:file])
      when :explicit
        install_wasm_file(release_info, detection[:file])
      when :no_match
        handle_no_match(detection, release_info)
      when :ambiguous
        handle_ambiguous(detection, release_info)
      end
    end

    private

    def fetch_release_info
      cmd = "gh release view -R #{@repo}"
      cmd += " #{@plugin.tag}" if @plugin.tag
      cmd += ' --json tagName,assets'

      json = `#{cmd}`
      raise "Failed to fetch release info for #{@repo}" unless $?.success?

      JSON.parse(json)
    end

    def extract_repo_name(repo)
      repo.split('/').last
    end

    def install_wasm_file(release_info, filename)
      output_dir = @plugin.output_dir || @global_config[:output_dir] || './plugins'
      output_dir = File.expand_path(output_dir)
      output_path = File.join(output_dir, filename)

      FileUtils.mkdir_p(output_dir)

      puts "📥 Downloading #{filename} to #{output_path}"

      download_cmd = "gh release download #{release_info['tagName']} -R #{@repo}"
      download_cmd += " --pattern #{filename}"
      download_cmd += " --dir #{output_dir}"
      download_cmd += ' --clobber'

      system(download_cmd)
      raise "Failed to download #{filename}" unless $?.success?

      puts "✅ Downloaded: #{filename}"

      {
        repo: @repo,
        tag: release_info['tagName'],
        file: filename
      }
    end

    def handle_no_match(detection, release_info)
      puts "⚠️  Could not auto-detect WASM file for #{@repo}"
      puts ''
      puts '📋 Candidates checked:'
      detection[:candidates].each do |candidate|
        puts "   - #{candidate}"
      end
      puts ''
      puts '📦 Available files in release:'
      detection[:available].each do |file|
        puts "   - #{file}"
      end
      puts ''
      ask_user_selection(detection[:available], release_info)
    end

    def handle_ambiguous(detection, release_info)
      puts "⚠️  Multiple WASM files found for #{@repo}"
      puts ''
      puts '📦 Available files in release:'
      detection[:files].each do |file|
        puts "   - #{file}"
      end
      puts ''
      ask_user_selection(detection[:files], release_info)
    end

    def ask_user_selection(available_files, release_info)
      print "Which file to download? [1-#{available_files.size}] or (s)kip: "
      choice = STDIN.gets.chomp

      if choice.downcase == 's'
        puts "⏭️  Skipped: #{@repo}"
        return nil
      end

      index = choice.to_i - 1
      if index >= 0 && index < available_files.size
        install_wasm_file(release_info, available_files[index])
      else
        puts '❌ Invalid selection'
        exit 1
      end
    end
  end
end
