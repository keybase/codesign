glob_to_regexp = require 'glob-to-regexp'
fs             = require 'fs'
path           = require 'path'
constants      = require '../constants'
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
    if @glob_list.length
      console.log "[#{path.relative root_dir, @working_path}] globber handling #{path.relative root_dir, path_to_file}"
    for g in @glob_list
      if g[0].match(/^[\s\#]/)
        console.log "   Skipping globber row #{g}"
      else if glob_to_regexp(g).test rel_path
        console.log "   Globber matched #{g}, ignoring!"
        res = constants.ignore_res.IGNORE
        break
      else
        console.log "   Globber didn't match #{g}..."
    cb res

  # -------------------------------------------------------------------------------------

  

  # -------------------------------------------------------------------------------------

  @from_file: (f, cb) ->
    full_path       = path.resolve f
    working_path    = path.dirname full_path
    await PresetBase.file_to_array f, defer glob_list
    gp = new GlobberPreset working_path, glob_list
    console.log "Generated globber from #{full_path}; glob_list = [#{glob_list.join ', '}]"

    cb gp

  # -------------------------------------------------------------------------------------

module.exports = GlobberPreset