fs                = require 'fs'
{ArgumentParser}  = require 'argparse'
{PackageJson}     = require './package'
{Summarizer}      = require './summarizer'
constants         = require './constants'
{to_md, from_md}  = require './markdown'

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
    sign   = subparsers.addParser 'sign',   {addHelp:true}
    verify = subparsers.addParser 'verify', {addHelp:true}
    sign.addArgument   ['-o', '--output'], {action: 'store', type:'string', help: 'output to a specific file'}
    sign.addArgument   ['-p', '--preset'], {action: 'store', type:'string', help: 'use an ignore preset'}
    sign.addArgument   ['-d', '--dir'],    {action: 'store', type:'string', help: 'the directory to sign', defaultValue: '.'}
    verify.addArgument ['-i', '--input'],  {action: 'store', type:'string', help: 'load a specific signature file'}
    verify.addArgument ['-d', '--dir'],    {action: 'store', type:'string', help: 'the directory to verify', defaultValue: '.'}

  # -------------------------------------------------------------------------------------------------------------------

  sign: ->
    output = @args.output or constants.defaults.filename
    await Summarizer.from_dir @args.dir, {ignore: [output]}, defer err, summ
    if err? then exit_err err
    o = summ.to_json_obj()
    await fs.writeFile output, to_md(o) + "\n", {encoding: 'utf8'}, defer err
    if err? then exit_err err

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
    if err? then exit_err err
    json_obj = from_md body

    # do our own analysis
    console.log "Analyzing, with ignore list: #{json_obj.ignore}"
    await Summarizer.from_dir @args.dir, {ignore: json_obj.ignore}, defer err, summ
    if err? then exit_err err

    # see if they match
    err = summ.compare_to_json_obj json_obj
    if err
      console.log "DOES NOT MATCH"
      console.log JSON.stringify err, null, 2
    else
      console.log "They match!"

  # -------------------------------------------------------------------------------------------------------------------

exports.run = ->
  m = new Main()
  m.run()