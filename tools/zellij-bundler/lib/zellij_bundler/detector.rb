module ZellijBundler
  class Detector
    def self.detect_wasm_file(repo_name, release_assets, explicit_filename = nil)
      return { status: :explicit, file: explicit_filename } if explicit_filename

      asset_names = release_assets.map { |a| a['name'] }
      wasm_files = asset_names.select { |name| name.end_with?('.wasm') }

      candidates = generate_candidates(repo_name)

      matches = candidates.select { |candidate| wasm_files.include?(candidate) }

      if matches.empty?
        { status: :no_match, candidates: candidates, available: wasm_files }
      elsif matches.length == 1
        { status: :found, file: matches.first }
      else
        { status: :ambiguous, files: matches, available: wasm_files }
      end
    end

    def self.generate_candidates(repo_name)
      candidates = []

      candidates << "#{repo_name}.wasm"

      clean_name = repo_name.sub(/^zellij[-_]/i, '')
      candidates << "#{clean_name}.wasm" if clean_name != repo_name

      candidates
    end
  end
end
