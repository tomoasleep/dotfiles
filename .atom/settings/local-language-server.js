const { AutoLanguageClient } = require('atom-languageclient')
const { spawn } = require('child_process')
const { existsSync } = require('fs')
const { resolve } = require('path')
const { consumeService, provideService } = require('./utils')

function activateClient(languageClient) {
  languageClient.activate()

  consumeService('linter-indie', '2.0.0', (service) => languageClient.consumeLinterV2(service))
  consumeService('atom-ide-busy-signal', '0.1.0', (service) => languageClient.consumeBusySignal(service))
  consumeService('console', '0.1.0', (service) => languageClient.consumeConsole(service))
  consumeService('datatip', '0.1.0', (service) => languageClient.consumeDatatip(service))

  provideService('autocomplete.provider', '2.0.0', languageClient.provideAutocomplete())
  provideService('code-format.range', '0.1.0', languageClient.provideCodeFormat())
  provideService('code-highlight', '0.1.0', languageClient.provideCodeHighlight())
  provideService('definitions', '0.1.0', languageClient.provideDefinitions())
  provideService('find-references', '0.1.0', languageClient.provideFindReferences())
  provideService('outline-view', '0.1.0', languageClient.provideOutlines())
  provideService('code-actions', '0.1.0', languageClient.provideCodeActions())
}

class RubyLanguageClient extends AutoLanguageClient {
  getGrammarScopes() { return [ 'source.ruby' ] }
  getLanguageName() { return 'Ruby' }
  getServerName() { return 'LocalLanguageServer' }

  startServerProcess(projectPath) {
    if (existsSync(resolve(projectPath, 'local-languageserver.rb'))) {
      return spawn('ruby', ['local-languageserver.rb'], { cwd: projectPath });
    }
  }
}

activateClient(new RubyLanguageClient());

class RSpecLanguageClient extends AutoLanguageClient {
  getGrammarScopes() { return [ 'source.ruby' ] }
  getLanguageName() { return 'Ruby' }
  getServerName() { return 'RSpec Local' }

  startServerProcess(projectPath) {
    if (existsSync(resolve(projectPath, 'local-rspec-server.rb'))) {
      return spawn('ruby', ['local-rspec-server.rb'], { cwd: projectPath });
    }
  }
}

activateClient(new RSpecLanguageClient());

class RubocopLanguageClient extends AutoLanguageClient {
  getGrammarScopes() { return [ 'source.ruby' ] }
  getLanguageName() { return 'Ruby' }
  getServerName() { return 'Rubocop Local' }

  startServerProcess(projectPath) {
    if (existsSync(resolve(projectPath, 'local-rubocop.rb'))) {
      return spawn('ruby', ['local-rubocop.rb'], { cwd: projectPath });
    }
  }
}

activateClient(new RubocopLanguageClient());
