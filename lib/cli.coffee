#!/usr/bin/env coffee

path = require 'path'
fs = require 'fs'
{convert} = require './convert'


exports.main = ->
  [interpreter, script, args...] = process.argv

  prefix = null

  if args.length > 0
    match = args[0].match(/^--prefix=(.+)$/)
    if match
      args.shift()
      prefix = match[1]

  #TODO: Expose --selectors and --no-selectors flags

  if args.length != 1
    console.log """
      Usage:
        #{path.basename(script)} [options] <html-file>

        --prefix=<string>     Prepends a string to each element function call
    """
    process.exit 1

  sourceFile = args.shift()

  html = fs.readFileSync sourceFile, 'utf8'
  convert html, process.stdout, {prefix}, (err) ->
    console.error err if err
