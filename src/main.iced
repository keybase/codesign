fs                = require 'fs'
{ArgumentParser}  = require 'argparse'
{PackageJson}     = require './package'
{Summarizer}      = require './summarizer'
constants         = require './constants'
{to_md, from_md}  = require './markdown'
{item_type_names} = require './constants'
tablify           = require 'tablify'
path              = require 'path'

class Main

  # -------------------------------------------------------------------------------------------------------------------

  constructor: ->
    @pkjson = new PackageJson()
    @args   = null
    @init_parser()

  # -------------------------------------------------------------------------------------------------------------------

  exit_err: (e) ->
    console.log "Error: #{e.toString()}"
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
    preset_choices = (k.toLoweCase() for k of constants.preset_aliases)
    sign.addArgument   ['-o', '--output'],  {action: 'store', type:'string', help: 'output to a specific file'}    
    sign.addArgument   ['-p', '--presets'], {action: 'store', type:'string', help: 'specify ignore presets, comma-separated',  defaultValue: 'git,dropbox,kb'}
    sign.addArgument   ['-d', '--dir'],     {action: 'store', type:'string', help: 'the directory to sign', defaultValue: '.'}
    verify.addArgument ['-i', '--input'],   {action: 'store', type:'string', help: 'load a specific signature file'}
    verify.addArgument ['-d', '--dir'],     {action: 'store', type:'string', help: 'the directory to verify', defaultValue: '.'}

  # -------------------------------------------------------------------------------------------------------------------

  valid_presets: -> (k.toLowerCase() for k of constants.presets)

  # -------------------------------------------------------------------------------------------------------------------

  get_preset_list: ->
    if not @args.preset?
      exit_err "Expected comma-separated list of presets (valid values=#{@valid_resets().join ','})"
    else
      presets = @args.preset.split ','
      for k in presets
        if not (k in @valid_presets())
          exit_err "Unknown preset #{k} (valid values=#{@valid_resets().join ','})"
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
    output  = @args.output or constants.defaults.filename
    await @get_ignore_list output, defer ignore
    console.log "Ignoring...#{ignore}"
    await Summarizer.from_dir @args.dir, {ignore, presets: @get_preset_list()}, defer err, summ
    if err? then @exit_err err
    o = summ.to_json_obj()
    await fs.writeFile output, to_md(o) + "\n", {encoding: 'utf8'}, defer err    
    if err? then @exit_err err
    console.log "Success! Output: #{output}"

  # -------------------------------------------------------------------------------------------------------------------

  run: ->
    @args = @ap.parseArgs()
    switch @args.subcommand_name
      when 'sign'   then @sign()
      when 'verify' then @verify()

  # -------------------------------------------------------------------------------------------------------------------

  verify: ->
    input = @args.input or constants.defaults.filename

    # load the file
    await fs.readFile input, 'utf8', defer err, body
    if err? then @exit_err "Couldn't open #{input}; if using another filename pass with -i <filename>"
    json_obj = from_md body

    # do our own analysis
    await Summarizer.from_dir @args.dir, {ignore: json_obj.ignore}, defer err, summ
    if err? then @exit_err err

    # see if they match
    err = summ.compare_to_json_obj json_obj
    if err
      table = []
      for f in err.missing
        table.push [f.path, "Missing"]
      for f in err.orphans
        table.push [f.path, "Unknown file"]
      for {got, expected} in err.wrong
        if got.item_type isnt expected.item_type then table.push [got.path, "Expected a #{item_type_names[expected.item_type]} and got a #{item_type_names[got.item_type]}"]
        else if got.size      isnt expected.size      then table.push [got.path, "Expected size #{expected.size} and got #{got.size}"]
        else if got.hash      isnt expected.hash      then table.push [got.path, "Bad contents (expected sha256 hash #{expected.hash[0...8]}...; got #{got.hash[0...8]}...)"]
        else if got.link      isnt expected.link      then table.push [got.path, "Expected link to '#{expected.link}' and got link to '#{got.link}'"]
        else if got.exec   and not expected.exec      then table.push [got.path, "Got unexpected user exec privileges"]  
        else if not got.exec and   expected.exec      then table.push [got.path, "Expected user exec privileges"]
      console.log tablify table
      console.log "BAD FILES: #{err.missing.length + err.orphans.length + err.wrong.length}"
      process.exit 1
    else
      console.log "Success!"

  # -------------------------------------------------------------------------------------------------------------------

exports.run = ->
  m = new Main()
  m.run()