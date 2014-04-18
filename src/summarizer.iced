crypto        = require 'crypto'
tablify       = require 'tablify'
path          = require 'path'
fs            = require 'fs'
{make_esc}    = require 'iced-error'
{PackageJson} = require './package'
{item_types}  = require './constants'

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
    @hash             = null
    @stats            = null # slightly different for symbolic links

  # -------------------------------------------------------------------------------------------------------------------

  load_traverse: (cb) ->
    esc = make_esc cb, "SummarizedItem::load"
    p   = path.join @summarizer.root_dir(), @parent_path, @fname
    await  fs.realpath p, esc defer @realpath
    await  fs.lstat    p, esc defer @stats
    if @stats?.isSymbolicLink()
      @item_type = item_types.SYMLINK
      await fs.readlink p, esc defer @link
    else if @stats.isFile()
      @item_type = item_types.FILE
      await @hash_contents esc defer @hash
    else
      @contents  = []
      @item_type = item_types.DIR
      await fs.readdir @realpath, esc defer fnames
      for f in fnames
        si = @subitem f
        await si.load_traverse esc defer()
        @contents.push si
      @contents.sort (a,b) -> a.fname.localeCompare b.fname
    cb()

  # -------------------------------------------------------------------------------------------------------------------

  subitem: (f) ->
    new SummarizedItem {
      fname:        f, 
      parent_path:  path.join @parent_path, @fname
      summarizer:   @summarizer
      depth:        @depth + 1
    }

  # -------------------------------------------------------------------------------------------------------------------

  signable_info: ->
    info =
      depth:        @depth
      parent_path:  @parent_path
      item_type:    @item_type
      fname:        @fname
      mode:         @stats.mode

    switch @item_type
      when item_types.FILE
        info.hash = @hash
        info.size = @stats.size
      when item_types.SYMLINK
        info.link = @link
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

  # -------------------------------------------------------------------------------------------------------------------

  hash_contents: (cb) ->
    fd   = fs.createReadStream @realpath
    hash = crypto.createHash 'sha256'
    hash.setEncoding 'hex'
    fd.on 'end', ->
      hash.end()
      cb null, hash.read()
    fd.on 'error', (e) -> 
      cb e
    fd.pipe hash

# =====================================================================================================================

class Summarizer

  constructor: (opts) ->
    @root_item     =    null
    @opts          =    opts or {}
    @opts.exclude  or=  []
    @opts.root_dir or=  '.'
    @opts.exclude.sort()

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

  compare_to_json_obj: (o) ->
    ###
    returns null if they are different; otherwise returns
    {
      missing: [array of missing files]
      wrong:   [files with incorrect hashes]
      orphans: [files of unknown origin]
    }
    ###
    err = 
      missing: []
      wrong:   []
      orphans: []

    return null

  # -------------------------------------------------------------------------------------------------------------------

  to_json_obj: ->
    ###
    a deterministic representation of the summary
    ###
    return {
      meta:
        version: new PackageJson().version()
      exclude: @opts.exclude
      found:   @root_item.walk_to_array()
    }

# =====================================================================================================================

exports.Summarizer = Summarizer

# =====================================================================================================================