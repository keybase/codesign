tablify        = require 'tablify'
path           = require 'path'
{make_esc}     = require 'iced-error'
{PackageJson}  = require './package'
constants      = require './constants'
{item_types}   = require './constants'
utils          = require './utils'
GitPreset      = require './preset/git'
DropboxPreset  = require './preset/dropbox'
GlobberPreset  = require './preset/globber'
XPlatformHash  = require './x_platform_hash'
finfo_cache    = require './file_info_cache'
vc             = constants.verify_codes

# =====================================================================================================================

class SummarizedItem

  constructor: ({parent_path, fname, summarizer, depth})  ->
    @parent_path      = parent_path
    @fname            = fname
    @summarizer       = summarizer
    @depth            = depth or 0
    @item_type        = null
    @realpath         = null
    @link             = null
    @contents         = null
    @finfo            = null
    @hash             = null
    @link_hash        = null
    @binary           = false

  # -------------------------------------------------------------------------------------------------------------------

  load_traverse: (cb) ->
    esc         = make_esc cb, "SummarizedItem::load"
    p           = path.join @summarizer.root_dir(), @parent_path, @fname
    @realpath   = path.resolve p
    await  finfo_cache @realpath, esc defer @finfo

    @item_type = @finfo.item_type
    @link      = @finfo.link
    @binary    = @finfo.is_binary()

    if @item_type is item_types.FILE
      await @finfo.hash constants.hash.ALG, constants.hash.ENCODING, esc defer @hash
    else if @item_type is item_types.DIR
      @contents  = []
      await @finfo.dir_contents esc defer fnames
      for f in fnames
        subpath = path.join @realpath, f
        await @summarizer.should_ignore subpath, esc defer ignore
        if not ignore
          si = @subitem f
          await si.load_traverse esc defer()
          @contents.push si
        #else
        #  console.log "Ignoring #{subpath}..."
      @contents.sort (a,b) -> a.fname.localeCompare(b.fname, 'us')
    else if @item_type is item_types.SYMLINK
      await @finfo.link_hash constants.hash.ALG, constants.hash.ENCODING, esc defer @link_hash
    cb()

  # -------------------------------------------------------------------------------------------------------------------

  subitem: (f) ->
    new SummarizedItem {
      fname:        f, 
      parent_path:  if @parent_path.length then "#{@parent_path}/#{@fname}" else @fname 
      summarizer:   @summarizer
      depth:        @depth + 1
    }

  # -------------------------------------------------------------------------------------------------------------------

  signable_info: ->
    info =
      depth:          @depth
      parent_path:    @parent_path
      item_type:      @item_type
      fname:          @fname
      path:           if @parent_path.length then "#{@parent_path}/#{@fname}" else @fname
      exec:           @finfo.is_user_executable_file()
      binary:         @binary

    switch @item_type
      when item_types.FILE
        info.hash               = @hash
        info.size               = @finfo.stat.size
        info.possible_win_link  = @finfo.possible_win_link
      when item_types.SYMLINK
        info.link               = @link
        info.link_hash          = @link_hash

    return info

  # -------------------------------------------------------------------------------------------------------------------

  walk_to_array: (_res)->
    ###
    returns an array of all items starting at this point,
    sorted in a predictable way; 
    ###
    _res or= []
    if @item_type is item_types.DIR
      _res.push @signable_info()
      c.walk_to_array(_res) for c in @contents
    else
      _res.push @signable_info()
    return _res

# =====================================================================================================================

class Summarizer

  constructor: (opts) ->
    @root_item     =    null
    @presets       =    [] # not the preset names, but the actual instances
    @opts          =    opts or {}
    @opts.ignore   or=  [] # specific files to ignore (such as '/SIGNED.md')
    @opts.presets  or=  [] # the preset names
    @opts.root_dir = path.resolve (@opts.root_dir or '.')
    @_create_presets()

  # -------------------------------------------------------------------------------------------------------------------

  should_ignore: (path_to_file, cb) ->
    res = false
    if path_to_file in @opts.ignore
      res = true
    else
      for p in @presets
        await p.handle @opts.root_dir, path_to_file, defer r
        if r is constants.ignore_res.IGNORE
          res = true
          break
        else if r is constants.ignore_res.DONT_IGNORE
          res = false
          break
    cb null, res

  # -------------------------------------------------------------------------------------------------------------------

  set_root_item: (ri) -> @root_item = ri

  # -------------------------------------------------------------------------------------------------------------------

  root_dir: -> @opts.root_dir

  # -------------------------------------------------------------------------------------------------------------------

  @from_dir: (dir, opts, cb) ->
    ###
    takes the path to a directory and returns a Summarize instance
    ###
    opts            = opts or {}
    opts.root_dir or= dir
    summ            = new Summarizer opts
    err             = null

    root_item = new SummarizedItem {
      fname:            '.'
      parent_path:      ''
      summarizer:       summ
    }
    await root_item.load_traverse defer err
    if not err? then summ.set_root_item root_item
    else
      console.log err
    cb err, summ

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
      else if (expected.item_type is item_types.FILE) and (got.item_type is item_types.SYMLINK) and (expected.hash.hash is got.link_hash)
        status = vc.ALT_SYMLINK_MATCH
      else if expected.item_type isnt got.item_type
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
        when 'none'     then continue
        else throw new Error "Unknown preset: #{p}"

    # and a special Globber one for the ignore list
    if @opts.ignore.length
      @presets.push new GlobberPreset @opts.root_dir, @opts.ignore

# =====================================================================================================================

exports.Summarizer = Summarizer

# =====================================================================================================================