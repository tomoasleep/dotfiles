observeGrammar = (grammarMatcher, callback) ->
  grammarTest = (grammar) ->
    grammarMatcher.test grammar.name

  atom.workspace.observeTextEditors (editor) ->
    editor.observeGrammar (grammar) ->
      callback.call(editor, grammar) if grammarTest(grammar)

didTheEditorActivate = (editor, callback) ->
  atom.workspace.observeActivePaneItem (item) ->
    callback.call(this, editor) if item is editor

buildEvent = (type) -> new CustomEvent(type, bubbles: true, cancelable: true)

delay = (callback) -> setTimeout(callback, 1)

triggerEvent = (name, caller = atom.workspaceView) ->
  caller.dispatchEvent(
    new CustomEvent(name, bubbles: true, cancelable: true))

{SelectListView} = require 'atom-space-pen-views'

class UserGeneralSelectListView extends SelectListView
  @createSpecializedClass: ({gather, execute}) ->
    class SpecializeClass extends this
      gather: gather
      execute: execute

  initialize: ->
    @setItems()

  viewForItem: (item) ->
    "<li>#{item}</li>"

  setItems: ->
    super(@gather())

  confirmed: (item) ->
    @execute?(item)

  cancelled: ->
    @panel?.destroy()

  show: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()

gitClone = (source, dest) ->
  command = 'git'
  args = ['clone', source, dest]
  onExit = (code) -> atom.notifications.addError('Git fetch: error') if code isnt 0
  new BufferedProcess({command, args, exit: onExit})

consumeService = (args...) ->
  atom.packages.serviceHub?.consume?(args...)

provideService = (args...) ->
  atom.packages.serviceHub?.provide?(args...)

module.exports = {
  observeGrammar, didTheEditorActivate,
  buildEvent, delay, triggerEvent,
  consumeService,
  provideService,
  UserGeneralSelectListView,
}
