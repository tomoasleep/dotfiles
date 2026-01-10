module ZellijBundler
  class Plugin
    attr_reader :repo, :options

    def initialize(repo, options = {})
      @repo = repo
      @options = options
    end

    def tag
      @options[:tag]
    end

    def output_dir
      @options[:to] || @options[:output]
    end

    def filename
      @options[:as]
    end

    def to_h
      {
        repo: @repo,
        tag: tag,
        output: output_dir,
        filename: filename
      }
    end
  end
end
