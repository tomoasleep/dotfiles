{ consumeService, delay, triggerEvent } = require './utils'

requireVimModeModule = (libPath) ->
  vimMode = atom.packages.loadPackage('vim-mode')
  path = require 'path'
  require path.join(vimMode.path, 'lib', libPath)

console.log 'loading vim-like.coffee'

# atom.services.consume 'vim-cmdline-mode', '^0.1.0', (service) ->
# atom.packages.onDidActivateInitialPackages ->
consumeService 'vim-cmdline-mode', '>=0.1.0', ->
  console.log 'Done: load initial packages'
  # service.getCommandRegistory()
  atom.vimcommands.register
    'w':
      'save the current buffer': ->
        process.nextTick =>
          triggerEvent('core:save', atom.views.getView(this))
    'w(rite) [<file>]':
      'save the current buffer': ->
        process.nextTick =>
          triggerEvent('core:save', atom.views.getView(this))
    'wq':
      'save and close the current buffer': ->
        process.nextTick =>
          triggerEvent('core:save', atom.views.getView(this))
          triggerEvent('core:close', atom.views.getView(this))
    'e(dit) [<file>]':
      'load the file to buffer': (filepath) ->
        process.nextTick ->
          atom.workspace.open(filepath) if filepath
    'newwindow [<file>]':
      'load the file to buffer': (filepath) ->
        process.nextTick ->
          if filepath
            atom.open pathsToOpen: [filepath]
    'new-root [<file>]':
      'add new rootpath': (filepath) ->
        process.nextTick ->
          atom.project?.addPath(filepath)
    'qall':
      'close current window': ->
        process.nextTick ->
          atom.close
    'q':
      'close the current buffer': ->
        process.nextTick =>
          triggerEvent('core:close', atom.views.getView(this))
    'q(uit)':
      'close the current buffer': ->
        process.nextTick =>
          triggerEvent('core:close', atom.views.getView(this))
    'vs':
      'split vertical': ->
        process.nextTick =>
          triggerEvent('pane:split-right', atom.views.getView(atom.workspace))
    'sp':
      'split horizontal': ->
        process.nextTick =>
          triggerEvent('pane:split-down', atom.views.getView(atom.workspace))
    'make':
      'execute make': ->
        process.nextTick =>
          triggerEvent('make-runner:run', atom.views.getView(this))
    'command [<command>]':
      'open command palette': (command) ->
        process.nextTick =>
          if command
            atom.commands.dispatch(atom.views.getView(this), command)
          else
            atom.commands.dispatch(atom.views.getView(this), 'command-palette:toggle')
    'project':
      'open project manager': ->
        process.nextTick =>
          triggerEvent('project-manager:list-projects', atom.views.getView(this))
    'settings':
      'open settng views': ->
        process.nextTick =>
          triggerEvent('settings-view:open', atom.views.getView(this))
    'finder':
      'open fuzzy finder': ->
        process.nextTick =>
          triggerEvent('fuzzy-finder:toggle-file-finder', atom.views.getView(this))
    'buffer [<buffer>]':
      'open fuzzy finder': (buffer) ->
        process.nextTick =>
          if buffer
            atom.workspace.open(buffer)
          else
            triggerEvent('fuzzy-finder:toggle-buffer-finder', atom.views.getView(this))
    'reload':
      'reload all views': ->
        process.nextTick =>
          triggerEvent('window:reload', atom.views.getView(this))
    'debugger':
      'open debugger': ->
        debugger
    'devtools':
      'toggle devtools': ->
        process.nextTick =>
          triggerEvent('window:toggle-dev-tools', atom.views.getView(this))
    'tree':
      'toggle tree': ->
        process.nextTick =>
          triggerEvent('tree-view:toggle', atom.views.getView(this))
    'silverBullet':
      'toggle silverBullet': ->
        process.nextTick =>
          triggerEvent('silver-bullet:toggle', atom.views.getView(this))

  # Hack vim mode motions
  do ->
    return
    {ScrollHalfScreenDown, ScrollHalfScreenUp} = requireVimModeModule 'scroll'

    ScrollHalfScreenUp::_moveCursor = ScrollHalfScreenUp::moveCursor
    ScrollHalfScreenUp::moveCursor = ->
      {row, column} = @editor.getCursorScreenPosition()
      currentFirstScreenRow = @editor.getFirstVisibleScreenRow()
      expectToMove = - (@rows.last - @rows.first) / 2
      dest = row + Math.min(expectToMove, currentFirstScreenRow - @rows.first)
      dest = Math.min(Math.max(dest, 0), @rows.final)
      @editor.setCursorScreenPosition([dest, column])

    ScrollHalfScreenDown::_moveCursor = ScrollHalfScreenDown::moveCursor
    ScrollHalfScreenDown::moveCursor = ->
      {row, column} = @editor.getCursorScreenPosition()
      currentFirstScreenRow = @editor.getFirstVisibleScreenRow()
      expectToMove = (@rows.last - @rows.first) / 2
      dest = row + Math.max(expectToMove, currentFirstScreenRow - @rows.first)
      dest = Math.min(Math.max(dest, 0), @rows.final)
      @editor.setCursorScreenPosition([dest, column])
