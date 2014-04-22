fs             = require 'fs'
path           = require 'path'
constants      = require '../constants'
PresetBase     = require './preset_base'
GlobberPreset  = require './globber'

# =======================================================================================

class GitPreset extends PresetBase

  constructor: ->
    globbers = {}

  # -------------------------------------------------------------------------------------

  handle: (root_dir, path_to_file, cb) ->
    paths = PresetBase.parent_paths @root_dir, path_to_file
    res   = constants.ignore_res.NONE
    for p in paths
      globber = @get_globber(p)
      console.log "Git checking #{path_to_file} against globber #{p}"
      await globber.handle root_dir, path_to_file, defer res
      if res isnt constants.ignore_res.NONE
        break
    cb res

  # -------------------------------------------------------------------------------------

  get_globber: (p) ->
    if not globbers[p]?
      globbers[p] = GlobberPreset.from_file path.join p, '.gitignore'
    return globbers[p]

  # -------------------------------------------------------------------------------------

# =======================================================================================

module.exports = GitPreset