# toggle tab bar
atom.commands.add 'atom-workspace',
  'user:toggle-tab-bar', ->
    @classList.toggle('disable-tab-bar')

atom.commands.add 'atom-workspace',
  'user:disable-tab-bar', ->
    @classList.add('disable-tab-bar')

atom.commands.dispatch(atom.views.getView(atom.workspace), 'user:disable-tab-bar')

atom.commands.add 'atom-workspace',
  'user:toggle-user-style', ->
    document.body.classList.toggle('toggle-user-style')

atom.commands.add 'atom-text-editor',
  'user:write': ->
    @dispatchEvent(
      new CustomEvent('core:save', bubbles: true, cancelable: true))
  'user:quit': ->
    @dispatchEvent(
      new CustomEvent('core:close', bubbles: true, cancelable: true))

atom.commands.add 'atom-workspace',
  'user:hub-clone', ->
    path = require 'path'
    _ = require 'underscore-plus'
    { createSpecializedClass } = require './utils'

    createSpecializedClass(
      gather: -> [],
      execute: (data) ->
        gitClone(data, path.join('~/Sources', _.last(data.split('/'))))
    ).show()

atom.commands.add 'atom-text-editor',
  'user:delete-to-slash', ->
    editor = @getModel()
    cursor = editor.getLastCursor()
    beginning = cursor.getBeginningOfCurrentWordBufferPosition(wordRegex: /([^\/\s]+[\/\s]*)|([\/\s]+)/)
    editor.selectToBufferPosition(beginning)
    editor.mutateSelectedText (selection) -> selection.deleteSelectedText()

atom.commands.add 'atom-text-editor',
  'user:debug', ->
    debugger

atom.commands.add 'atom-text-editor',
  'user:ipsj', ->
    mapping = {
      '、': '，',
      '。': '．',
    }

    editor = @getModel()
    editor.transact ->
      for k, v of mapping
        editor.scan(new RegExp(k, 'g'), ({ replace }) -> replace(v))

atom.commands.add 'atom-text-editor',
  'user:close-notifications', ->
    notifications = atom.notifications.getNotifications()
    for notification in notifications
      if notification.isDismissable() and not notification.isDismissed()
        notification.dismiss()

atom.commands.add 'atom-workspace', 'user:focus-active-editor', (event) ->
  workspace = @getModel()
  textEditor = workspace.getActiveTextEditor()
  return unless textEditor
  atom.views.getView(textEditor)?.focus()

atom.commands.add 'atom-text-editor', 'user:cancel-select', (event) ->
  editor = @getModel()
  selection = editor.getLastSelection()
  if selection
    editor.setCursorBufferPosition(selection.getBufferRange().start)
  editor.clearSelections()

atom.commands.add 'atom-workspace', 'user:go-found', (event) ->
  atom.commands.dispatch(atom.views.getView(atom.workspace.getActiveTextEditor()), 'user:find-next')
  atom.commands.dispatch(this, 'user:focus-active-editor')

atom.commands.add 'atom-text-editor', 'user:find-next', (event) ->
  atom.commands.dispatch(this, 'find-and-replace:find-next')
  atom.commands.dispatch(atom.views.getView(atom.workspace.getActiveTextEditor()), 'user:cancel-select')
  atom.commands.dispatch(this, 'user:focus-active-editor')

atom.commands.add 'atom-text-editor', 'user:find-previous', (event) ->
  atom.commands.dispatch(this, 'find-and-replace:find-previous')
  atom.commands.dispatch(atom.views.getView(atom.workspace.getActiveTextEditor()), 'user:cancel-select')
  atom.commands.dispatch(this, 'user:focus-active-editor')

atom.commands.add 'atom-text-editor', 'user:use-selection-as-find-pattern', (event) ->
  atom.commands.dispatch(this, 'find-and-replace:use-selection-as-find-pattern')
  atom.commands.dispatch(this, 'user:focus-active-editor')

atom.commands.add 'atom-workspace', 'user:edit-setting-scripts', (event) ->
  path = require 'path'
  atom.open(pathsToOpen: path.resolve(__dirname, '../'))

atom.commands.add 'atom-workspace', 'user:fail-promise', (event) ->
  Promise.reject(Error("hoge"))
