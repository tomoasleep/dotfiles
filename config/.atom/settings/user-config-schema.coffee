atom.config.setSchema 'user.maxPaneLength',
  type: 'integer'
  default: 8
  minimun: 1

atom.config.setSchema 'user.ignoreSettingFiles',
  type: 'array'
  default: []
  items:
    type: 'string'
