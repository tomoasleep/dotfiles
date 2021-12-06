{ disposeTabs } = require './utils'
{ filter } = require 'underscore-plus'

maxPaneLength = do ->
  atom.config.observe 'user.maxPaneLength', (value) ->
    maxPaneLength = value
  atom.config.get 'user.maxPaneLength'

# Dispose each pane
disposeTabs = (pane) ->
  items = pane.getItems()
  activeItem = pane.getActiveItem()
  itemsWillDispose = filter(items.slice(maxPaneLength), (item) -> not (item is activeItem))
  if itemsWillDispose.length
    for item in itemsWillDispose
      atom.notifications.addInfo "Closed: #{item.getTitle?()}"
      pane.destroyItem(item)

# Move activated pane to first pane
do ->
  timeoutId = null
  atom.workspace.onDidChangeActivePaneItem (item) ->
    pane = atom.workspace.paneForItem(item)
    callback = ->
      timeoutId = null
      if pane
        pane.moveItem(item, 0)
        disposeTabs(pane)
    clearTimeout(timeoutId) if timeoutId
    timeoutId = setTimeout(callback, 1000)
