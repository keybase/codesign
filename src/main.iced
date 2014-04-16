{ArgumentParser} = require 'argparse'
{PackageJson}    = require './package'

class Main
  constructor: ->
    @pkjson = new PackageJson()
    @init_parser()

  init_parser: ->
    @ap     = new ArgumentParser {
      addHelp:      true
      version:      @pkjson.version()
      description:  'keybase.io directory summarizer'
      prog:         @pkjson.bin()     
    }

  run: ->
    console.log "It's really running."


exports.run = ->
  (new Main()).run()