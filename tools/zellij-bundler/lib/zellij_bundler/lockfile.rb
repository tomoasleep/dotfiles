require 'yaml'

module ZellijBundler
  class Lockfile
    LOCKFILE_PATH = 'zellij-bundles-lock.yaml'
    VERSION = '1.0'

    def self.load
      return new({}) unless File.exist?(LOCKFILE_PATH)

      data = YAML.load_file(LOCKFILE_PATH)
      new(data)
    end

    def initialize(data = {})
      @data = data || {}
      @data['version'] ||= VERSION
      @data['plugins'] ||= []
    end

    def add_or_update(plugin_info)
      @data['plugins'] = @data['plugins'].reject { |p| p['repo'] == plugin_info[:repo] }
      @data['plugins'] << {
        'repo' => plugin_info[:repo],
        'tag' => plugin_info[:tag],
        'file' => plugin_info[:file],
        'downloaded_at' => plugin_info[:downloaded_at],
        'size' => plugin_info[:size]
      }
    end

    def remove(repo)
      @data['plugins'] = @data['plugins'].reject { |p| p['repo'] == repo }
    end

    def find_by_repo(repo)
      @data['plugins'].find { |p| p['repo'] == repo }
    end

    def remove(repo)
      @data['plugins'] = @data['plugins'].reject { |p| p['repo'] == repo }
    end

    def find_by_repo(repo)
      @data['plugins'].find { |p| p['repo'] == repo }
    end

    def all
      @data['plugins']
    end

    def save
      File.write(LOCKFILE_PATH, @data.to_yaml)
    end
  end
end
