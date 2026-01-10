module ZellijBundler
  class Dsl
    attr_reader :plugins, :config

    def self.evaluate(file)
      dsl = new
      dsl.instance_eval(File.read(file), file)
      dsl
    rescue StandardError => e
      raise "Error evaluating DSL file: #{e.message}\n  at #{file}:#{e.backtrace.first}"
    end

    def initialize
      @config = { output_dir: './plugins', force: false }
      @plugins = []
    end

    def set(key, value)
      @config[key] = value
    end

    def plugin(repo, options = {}, &block)
      plugin = Plugin.new(repo, options)
      plugin.instance_eval(&block) if block
      @plugins << plugin
    end
  end
end
