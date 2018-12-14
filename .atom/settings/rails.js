"use babel";

import { dirname, join } from 'path'
import { existsSync } from 'fs'
import { provideService } from './utils';
import { Range } from 'atom';

function getTargetRelativePath(event) {
  const model = event.currentTarget.getModel()
  return model.getPath && atom.project.relativize(model.getPath())
}

function tryToOpen(pathes) {
  const pathesToOpen = pathes.filter((path) => existsSync(atom.project.resolvePath(path)))
  pathesToOpen[0] && atom.workspace.open(pathesToOpen[0])
}

atom.commands.add('atom-text-editor', {
  'user:rails-go-to-spec': (event) => {
    const fpath = getTargetRelativePath(event)
    if (fpath) {
      atom.workspace.open(fpath.replace(/^app/, 'spec').replace(/\.rb$/, '_spec.rb'))
    }
  },
  'user:rails-go-to-mutation-test': (event) => {
    const fpath = getTargetRelativePath(event)
    if (fpath) {
      atom.workspace.open(fpath.replace(/^app\/models\/(\w+)\/graph\/(\w+)\/mutations\/(\w+)\.rb$/, 'spec/requests/$1/$2/graphql/mutation_$3_spec.rb'))
    }
  },
  'user:rails-go-to-graphql': (event) => {
    const fpath = getTargetRelativePath(event)
    if (fpath) {
      atom.workspace.open(fpath.replace(/^spec\/requests\/(\w+)\/(\w+)\/graphql\/mutation_(\w+)_spec\.rb$/, 'app/models/$1/graph/$2/mutations/$3.rb'))
    }
  },
  'user:rails-go-to-translation': (event) => {
    const fpath = getTargetRelativePath(event)
    const originPath = [
      fpath.replace(/^(app|spec)\/models/, 'config/locales'),
      fpath.replace(/^(app|spec)/, 'config/locales'),
    ]
    const nestedPathes = originPath.map((opath) => {
      let dir = opath
      let results = []

      while (dir && dir != dirname(dir)) {
        dir = dirname(dir)
        results.push(join(dir, 'ja.yml'))
      }

      return results
    })
    tryToOpen(Array.prototype.concat.apply([], nestedPathes))
  },
})

yamlKeyRegexp = /(^\s*)((\w+\/?)+):\s*$/

provideService('hyperclick', '0.1.0', {
  priority: 1,
  grammarScopes: ['source.yaml'],
  getSuggestion(textEditor, position) {
    // if (!atom.project) { return }
    const lineText = textEditor.lineTextForBufferRow(position.row)
    const match = yamlKeyRegexp.exec(lineText)

    if (match) {
      const prefixLength = match[1].length
      const word = match[2]
      const modelPath = atom.project.resolvePath(join('app/models/', `${word}.rb`))

      if (existsSync(modelPath)) {
        return {
          range: new Range([position.row, prefixLength], [position.row, prefixLength + word.length]),
          callback() {
            atom.workspace.open(modelPath)
          },
        }
      }
    }
  },
})
