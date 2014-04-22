glob_to_regexp = require 'glob-to-regexp'
fs             = require 'fs'
path           = require 'path'
constants      = require './constants'
PresetBase     = require './preset_base'

# =======================================================================================

class GlobberPreset extends PresetBase

  constructor: (working_path, glob_list) ->
    # working_path: where the glob_list is considered relative to.
    # glob_list:    array of strings
    @glob_list    = glob_list
    @working_path = working_path

  # -------------------------------------------------------------------------------------

  handle: (root_dir, path_to_file, cb) ->
    res      = constants.ignore_res.NONE 
    rel_path = path.relative @working_path, path.join(root_dir, path_to_file)
    console.log "Globber handling #{rel_path} in context #{@working_path}"
    for g in @glob_list
      if g[0].match(/^[\s\#]/)
        console.log "Skipping globber row #{g}"
      else if glob_to_regexp(g).test rel_path
        console.log "Globber matched #{g} to #{rel_path} in context #{@working_path}"
        res = constants.ignore_res.IGNORE
        break
    cb res

  # -------------------------------------------------------------------------------------

  @from_file: (f) ->
    full_path       = path.resolve f
    working_path    = path.dirname full_path
    await PresetBase.file_to_array f, defer glob_list
    gp = new GlobberPreset working_path, glob_list
    console.log "Generated globber from #{full_path}; glob_list = [#{glob_list.join ', '}]"
    return gp

  # -------------------------------------------------------------------------------------

module.exports = GlobberPreset