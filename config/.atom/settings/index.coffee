fs = require 'fs'
path = require 'path'
{ contains } = require 'underscore-plus'

require './user-config-schema'

scriptsNotRead = ['index.coffee'].concat(atom.config.get('user:ignoreSettingFiles') ? [])

onlyScripts = (name) ->
  /(\.js|\.coffee)$/i.test(path.extname(name)) and
    not contains(scriptsNotRead, path.basename(name))

# Load each script in this directory
for scriptName in fs.readdirSync(__dirname).filter(onlyScripts)
  try
    require path.join(__dirname, scriptName)
  catch error
    console.error(scriptName, error)
    atom.notifications.addError "Failed to load #{scriptName}",
      detail: error.message
      stack: error.stack
      dismissable: true
