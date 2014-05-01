fs                = require 'fs'
{ArgumentParser}  = require 'argparse'
tablify           = require 'tablify'
path              = require 'path'
{PackageJson}     = require './package'
{Summarizer}      = require './summarizer'
constants         = require './constants'
{to_md, from_md}  = require './markdown'
{item_type_names} = require './constants'
utils             = require './utils'
log               = require 'iced-logger'
vc                = constants.verify_codes


class Main

  # -------------------------------------------------------------------------------------------------------------------

  constructor: ->
    @pkjson = new PackageJson()
    @args   = null
    @init_parser()

  # -------------------------------------------------------------------------------------------------------------------

  exit_err: (e) ->
    log.error e.toString()
    process.exit 1

  # -------------------------------------------------------------------------------------------------------------------

  init_parser: ->
    @ap     = new ArgumentParser {
      addHelp:      true
      version:      @pkjson.version()
      description:  'keybase.io directory summarizer'
      prog:         @pkjson.bin()     
    }
    subparsers = @ap.addSubparsers {
      title:  'subcommands'
      dest:   'subcommand_name'
    }
    sign           = subparsers.addParser 'sign',   {addHelp:true}
    verify         = subparsers.addParser 'verify', {addHelp:true}
    tojson         = subparsers.addParser 'tojson', {addHelp:true}

    sign.addArgument      ['-o', '--output'],  {action: 'store', type:'string', help: 'output to a specific file'}    
    sign.addArgument      ['-p', '--presets'], {action: 'store', type:'string', help: 'specify ignore presets, comma-separated',  defaultValue: 'git,dropbox,kb'}
    sign.addArgument      ['-d', '--dir'],     {action: 'store', type:'string', help: 'the directory to sign', defaultValue: '.'}
    sign.addArgument      ['-q', '--quiet'],   {action: 'storeTrue', help: 'withhold output unless an error'}

    verify.addArgument    ['-i', '--input'],   {action: 'store', type:'string', help: 'load a specific signature file'}
    verify.addArgument    ['-d', '--dir'],     {action: 'store', type:'string', help: 'the directory to verify', defaultValue: '.'}
    verify.addArgument    ['-q', '--quiet'],   {action: 'storeTrue', help: 'withhold output unless an error'}
    verify.addArgument    ['-s', '--strict'],  {action: 'storeTrue', help: 'fail on warnings (typically cross-platform problems)'}

    tojson.addArgument    ['-i', '--input'],   {action: 'store', type:'string', help: 'load a specific signature file to convert to JSON'}

  # -------------------------------------------------------------------------------------------------------------------

  valid_presets: -> (k.toLowerCase() for k of constants.presets)

  # -------------------------------------------------------------------------------------------------------------------

  get_preset_list: ->
    if not @args.presets?
      @exit_err "Expected comma-separated list of presets (valid values=#{@valid_presets().join ','})"
    else
      presets = @args.presets.split ','
      for k in presets
        if not (k in @valid_presets())
          @exit_err "Unknown preset #{k} (valid values=#{@valid_presets().join ','})"
      return presets


  # -------------------------------------------------------------------------------------------------------------------

  get_ignore_list: (output, cb) ->
    # if the output file is inside the analyzed directory, add
    # it to the ignore array. Otherwise don't worry about it.
    rel_ignore = path.relative(@args.dir, output).split(path.sep).join('/')
    ignore = if rel_ignore[...2] isnt '..' then ["/#{rel_ignore}"] else []
    cb ignore

  # -------------------------------------------------------------------------------------------------------------------

  sign: ->
    output  = @args.output or constants.defaults.FILENAME
    await @get_ignore_list output, defer ignore
    await Summarizer.from_dir @args.dir, {ignore, presets: @get_preset_list()}, defer err, summ
    if err? then @exit_err err
    o = summ.to_json_obj()
    await fs.writeFile output, to_md(o) + "\n", {encoding: 'utf8'}, defer err    
    if err? then @exit_err err
    if not @args.quiet
      log.info "Success! Output: #{output}"

  # -------------------------------------------------------------------------------------------------------------------

  run: ->
    @args = @ap.parseArgs()
    switch @args.subcommand_name
      when 'sign'   then @sign()
      when 'verify' then @verify()
      when 'tojson' then @to_json()

  # -------------------------------------------------------------------------------------------------------------------

  to_json: ->
    input = @args.input or constants.defaults.FILENAME
    # load the file
    await fs.readFile input, 'utf8', defer err, body
    if err? then @exit_err "Couldn't open #{input}; if using another filename pass with -i <filename>"
    json_obj = from_md body

    if not json_obj?
      @exit_err "Failed to parse/load #{input}"
    else
      log.console.log JSON.stringify json_obj, null, 2

  # -------------------------------------------------------------------------------------------------------------------

  verify: ->
    input = @args.input or constants.defaults.FILENAME

    # load the file
    await fs.readFile input, 'utf8', defer err, body
    if err? then @exit_err "Couldn't open #{input}; if using another filename pass with -i <filename>"
    json_obj = from_md body

    if not json_obj?
      @exit_err "Failed to parse/load #{input}"

    # do our own analysis
    await Summarizer.from_dir @args.dir, {ignore: json_obj.ignore, presets: json_obj.presets}, defer err, summ
    if err? then @exit_err err

    # see if they match
    await summ.compare_to_json_obj json_obj, defer probs
    err_table  = []
    warn_table = []
    for [code, {got, expected}] in probs
      label     = if code < 100 then 'warning' else 'ERROR'
      fname     = got?.path or expected?.path
      msg       = switch code
        when vc.ALT_HASH_MATCH then     'hash matches when disregarding CRLF line-endings'
        when vc.ALT_SYMLINK_MATCH then  'symlink matches file contents (possible Windows issue)'
        when vc.MISSING_DIR then        'directory is missing'
        when vc.ORPHAN_DIR then         'unknown directory found'
        when vc.MISSING_FILE then       'file is missing'
        when vc.ORPHAN_FILE then        'unknown file found'
        when vc.HASH_MISMATCH then      "file contents do not match (expected #{expected.hash.hash[0...8]}... but got #{got.hash.hash[0...8]}...)"
        when vc.WRONG_ITEM_TYPE then    "expected a #{utils.item_type_name expected.item_type} but got a #{utils.item_type_name got.item_type}"
        when vc.WRONG_EXEC_PRIVS then   "unexpected execution privileges (expected exec=#{expected.exec} but got exec=#{got.exec})"
        when vc.WRONG_SYMLINK then      "expected symlink to `#{expected.link}` but got `#{got.link}`"
      if (code < 100) and (not @args.strict)
        warn_table.push [msg, fname]
      else
        err_table.push [msg, fname]
    if warn_table.length and not @args.quiet
      log.info utils.plain_tablify warn_table
    if err_table.length
      log.error utils.plain_tablify err_table
      log.error "Exited after #{err_table.length} error(s)"
    else
      if not @args.quiet
        log.info  "Success! #{json_obj.found.length} items checked#{if warn_table.length then ' with ' + warn_table.length + ' warning(s); pass --strict to prevent success on warnings; --quiet to hide warnings' else ''}"

  # -------------------------------------------------------------------------------------------------------------------

exports.run = ->
  m = new Main()
  m.run()