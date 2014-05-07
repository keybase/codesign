path              = require 'path'
{make_esc}        = require 'iced-error'
{PackageJson}     = require './package'
constants         = require './constants'
{item_types}      = require './constants'
{SummarizedItem}  = require './summarized_item'
GitPreset         = require './preset/git'
KbPreset          = require './preset/kb'
DropboxPreset     = require './preset/dropbox'
GlobberPreset     = require './preset/globber'
vc                = constants.verify_codes

# =====================================================================================================================
#
# This is the mother class.
#
#     1. cs = new CodeSign(dir, opts)
#     2. cs.walk(cb) # calls back with errors on walking
#     ...
#     from there, you may:
#        - compare to payload_obj
#        - convert to payload_str
#        - convert to json_obj
#        - add a signature
#        - check a signature
#        - etc.
#
# =====================================================================================================================

class CodeSign

  constructor: (root_dir, opts) ->
    @root_dir       =    path.resolve root_dir
    @root_item      =    null
    @presets        =    [] # not the preset names, but the actual instances
    @opts           =    opts or {}
    @opts.ignore    or=  [] # specific files to ignore (such as '/SIGNED.md')
    @opts.presets   or=  [] # the preset names
    @_init_done     =    false
    @_create_presets()

  # -------------------------------------------------------------------------------------------------------------------

  walk: (cb) ->
    esc         = make_esc cb, "SummarizedItem::load"
    @root_item = new SummarizedItem {
      fname:            '.'
      parent_path:      ''
      codesign:         this
    }
    await @root_item.load_traverse esc defer()
    @_init_done = true
    cb()

  # -------------------------------------------------------------------------------------------------------------------
  # semi-private items, used by summarized_item objects
  # -------------------------------------------------------------------------------------------------------------------

  _should_ignore: (path_to_file, cb) ->
    res = false
    if path_to_file in @opts.ignore
      res = true
    else
      for p in @presets
        await p.handle @root_dir, path_to_file, defer r
        if r is constants.ignore_res.IGNORE
          res = true
          break
        else if r is constants.ignore_res.DONT_IGNORE
          res = false
          break
    cb null, res

  # -------------------------------------------------------------------------------------------------------------------

  hash_match: (h1, h2) -> (not (h1? or h2?)) or (h1?.hash is h2?.hash)

  # -------------------------------------------------------------------------------------------------------------------

  hash_alt_match: (h1, h2) -> (not (h1? or h2?)) or (h1?.hash is h2?.hash) or (h1?.alt_hash is h2?.hash) or (h1?.hash is h2?.alt_hash)

  # -------------------------------------------------------------------------------------------------------------------

  compare_to_json_obj: (obj, cb) ->
    ###
    calls back with an array of problems
    each item in the array is a pair [code, {got, expected}]
    ###
    probs = []

    got_by_path = {}
    exp_by_path = {}

    got_by_path[f.path] = f for f in @to_json_obj().found
    exp_by_path[f.path] = f for f in obj.found

    for p1, expected of exp_by_path
      status = vc.OK
      if not (got = got_by_path[p1])?
        if expected.item_type is item_types.DIR
          status = vc.MISSING_DIR
        else
          status = vc.MISSING_FILE
      else if (expected.item_type is item_types.SYMLINK) and (got.item_type is item_types.FILE) and (expected.link is got.possible_win_link)
        status = vc.ALT_SYMLINK_MATCH
      else if (expected.item_type is item_types.FILE) and (got.item_type is item_types.SYMLINK) and @hash_alt_match(expected.hash, got.link_hash)
        status = vc.ALT_SYMLINK_MATCH
      else if expected.item_type isnt got.item_type
        if (expected.item_type is item_types.FILE) and (got.item_type is item_types.SYMLINK)
          console.log "expected hash: #{expected.hash.hash} (or #{expected.hash.alt_hash}); got link_hash: #{got.link_hash.hash}"
        status = vc.WRONG_ITEM_TYPE        
      else if (expected.item_type is item_types.FILE) and (expected.exec isnt got.exec)      
        status = vc.WRONG_EXEC_PRIVS
      else if (expected.link isnt got.link)
        status = vc.WRONG_SYMLINK
      else if not @hash_alt_match got.hash, expected.hash
        status = vc.HASH_MISMATCH
      else if not @hash_match     got.hash, expected.hash
        status = vc.ALT_HASH_MATCH
      if status isnt vc.OK
        probs.push [status, {got: (got or null), expected: (expected or null)}]

    for p1, got of got_by_path when not exp_by_path[p1]?
      if got.item_type is item_types.DIR
        probs.push   [vc.ORPHAN_DIR,     {got, expected: null}]
      else
        probs.push   [vc.ORPHAN_FILE,    {got, expected: null}]

    probs.sort (a,b) -> a[0] - b[0]
    cb probs

  # -------------------------------------------------------------------------------------------------------------------

  to_json_obj: ->
    ###
    a deterministic representation of the summary
    ###
    return {
      meta:
        version: new PackageJson().version()
      ignore:  @opts.ignore
      presets: @opts.presets
      found:   @root_item.walk_to_array()
    }

  # -------------------------------------------------------------------------------------------------------------------

  _create_presets: ->
    # let's make an actual preset for each one requested in the opts
    for p in @opts.presets
      switch p
        when 'git'      then @presets.push new GitPreset()
        when 'dropbox'  then @presets.push new DropboxPreset()
        when 'kb'       then @presets.push new KbPreset()
        when 'none'     then continue
        else throw new Error "Unknown preset: #{p}"

    # and a special Globber one for the ignore list
    if @opts.ignore.length
      @presets.push new GlobberPreset @root_dir, @opts.ignore

# =====================================================================================================================

exports.CodeSign = CodeSign

# =====================================================================================================================