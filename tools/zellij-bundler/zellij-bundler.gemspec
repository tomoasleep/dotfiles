Gem::Specification.new do |spec|
  spec.name          = 'zellij-bundler'
  spec.version       = '0.1.0'
  spec.authors       = ['tomoasleep']
  spec.email         = ['tomoasleep@example.com']

  spec.summary       = 'Zellij plugin downloader and manager'
  spec.description   = 'Download and manage Zellij plugins from GitHub releases'
  spec.homepage      = 'https://github.com/tomoasleep/zellij-bundler'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.files = Dir.glob('{lib,bin}/**/*') + ['README.md']
  spec.bindir        = 'bin'
  spec.executables   = ['zellij-bundler']
  spec.require_paths = ['lib']

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tomoasleep/zellij-bundler'
end
