path            = require 'path'
fs              = require 'fs'
crypto          = require 'crypto'
LockTable       = require('./lock').Table
utils           = require './utils'
XPlatformHash   = require './x_platform_hash'

# =============================================================================
#
# file_info 'some_path', (err, finfo) -> ...
#
#   calls back with a FileInfo object, which will expose:
#      - stat
#      - lstat
#      - hash()               <-- cb based, but with caching
#      - is_binary()          <-- cb based, but with caching
#      - is_executable_file() <-- returns true if a file (not dir) and user exec
#
# and uses an internal cache so it never repeats these lookups
# 
# =============================================================================

class FileInfo
  constructor: (full_path) ->
    @_BINARY_BYTE_STUDY = 8000 # this is how git does it
    @full_path          = full_path
    @err                = null
    @lstat              = null
    @stat               = null
    @_hash              = {}
    @_is_binary         = null
    @_dir_contents      = null
    @_locks             = new LockTable()
    @_init_done         = false
    @_link              = null


  # ---------------------------------------------------------------------------

  init: (cb) ->
    await 
      fs.stat   @full_path, defer err1, @stat
      fs.lstat  @full_path, defer err2, @lstat
    @err = err1 or err2
    @_init_done = true
    cb()

  # ---------------------------------------------------------------------------

  check_init: ->
    if not @_init_done then throw new Error "Init not done on #{@full_path}"

  # ---------------------------------------------------------------------------

  hash: (alg, encoding, cb) ->
    @check_init()
    k = "#{alg}|#{encoding}"
    await @_locks.acquire k, defer(lock), true  
    if (not @err) and (not @_hash[k]?)
      h    = new XPlatformHash {alg, encoding}
      fd   = fs.createReadStream @full_path
      await h.hash fd, defer @err, @_hash[k]
    lock.release()
    cb @err, @_hash[k]

  # ---------------------------------------------------------------------------

  dir_contents: (cb) ->
    @check_init()
    await @_locks.acquire 'dir_contents', defer(lock), true
    if (not @err) and (not @_dir_contents?)
      await fs.readdir @full_path, defer @err, fnames
      if fnames? then @_dir_contents = (f for f in fnames when f isnt '.')
    lock.release()
    cb @err, @_dir_contents

  # ---------------------------------------------------------------------------

  readlink: (cb) ->
    @check_init()
    await @_locks.acquire 'readlink', defer(lock), true
    if (not @err) and (not @_link?)
      await fs.readlink @full_path, defer @err, @_link
    lock.release()
    cb @err, @_link

  # ---------------------------------------------------------------------------

  is_binary: (cb) ->
    @check_init()
    await @_locks.acquire 'is_binary', defer(lock), true
    if (not @err) and (not @_is_binary?)
      if not @lstat.isFile()
        @_is_binary = false
      else
        await fs.open @full_path, 'r', defer @err, fd
        if not @err
          len = Math.min @stat.size, @_BINARY_BYTE_STUDY
          if not len
            @_is_binary = true
          else
            b   = new Buffer len
            await fs.read  fd, b, 0, len, 0, defer @err, bytes_read
            if bytes_read isnt len
              console.log "#Requested #{len} bytes of #{@full_path}, but got #{bytes_read}"
            @_is_binary = false
            for i in [0...b.length]
              if b.readUInt8(i) is 0
                @_is_binary = true
                break
          await fs.close fd, defer @err
    lock.release()
    cb @err, @_is_binary

  # ---------------------------------------------------------------------------

  is_user_executable_file: -> 
    @check_init()
    @lstat.isFile() and !!(parseInt(100,8) & @lstat.mode)    

  # ---------------------------------------------------------------------------


# =============================================================================

class InfoCollection

  # ---------------------------------------------------------------------------

  constructor: ->
    @_locks = new LockTable()
    @_cache = {} # keyed by file absolute path

  # ---------------------------------------------------------------------------

  get: (f, cb) ->
    f = path.resolve f
    await @_locks.acquire f, defer(lock), true
    if not @_cache[f]?      
      @_cache[f] = new FileInfo f
      await @_cache[f].init defer()
    lock.release()
    cb @_cache[f].err, @_cache[f]

  # ---------------------------------------------------------------------------

ic = new InfoCollection()

# =============================================================================

module.exports = (f, cb) -> ic.get f, cb