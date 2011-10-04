#!/usr/bin/env coffee

path = require 'path'
fs = require 'fs'
{convert} = require './convert'


exports.main = ->
  [interpreter, script, args...] = process.argv

  if args.length == 0
    console.log "Usage: #{path.basename(script)} <html-file>"
    process.exit 1

  html = fs.readFileSync args[0], 'utf8'
  convert html, process.stdout, (err) ->
    console.error err if err
