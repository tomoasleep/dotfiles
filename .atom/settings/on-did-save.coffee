{ exec } = require 'child_process'

atom.workspace.observeTextEditors (editor) ->
  editor.getBuffer()?.onDidSave (event) ->
    command = "git wip save \"WIP from atom (#{event.path})\" --editor -- #{event.path}"
    exec command, cwd: atom.project.path
