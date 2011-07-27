{inspect} = require 'util'
htmlparser = require 'htmlparser'
{readFileSync} = require 'fs'


stringLiteral = (html) ->
  inspect html.trim()


class Converter

  constructor: ->
    @depth = 0

  convert: (html) ->
    handler = new htmlparser.DefaultHandler (err, dom) =>
      throw err if err
      @visitArray dom, 0
    parser = new htmlparser.Parser(handler)
    parser.parseComplete(html)

  emit: (code) ->
    console.log Array(@depth + 1).join('  ') + code

  visitNode: (node) ->
    type = node.type.charAt(0).toUpperCase() + node.type.substring(1)
    @['visit' + type](node)

  visitArray: (array) ->
    for node in array
      @visitNode node

  nest: (callback) ->
    @depth++
    result = callback()
    @depth--
    result

  visitTag: (tag) ->
    code = tag.name

    # Force attribute ordering of `id`, `class`, then others.
    attribs = []
    if tag.attribs?
      extractAttrib = (key) ->
        value = tag.attribs[key]
        if value
          attribs.push [key, value]
          delete tag.attribs[key]
      extractAttrib 'id'
      extractAttrib 'class'
      for key, value of tag.attribs
        attribs.push [key, value]

    # Render attributes
    attribs = for [key, value] in attribs
      " #{key}: #{stringLiteral value}"
    code += attribs.join(',')

    # Render content
    endTag = (suffix) =>
      if suffix
        code += ',' if attribs.length > 0
        code += suffix
      @emit code
    if (children = tag.children)?
      if children.length == 1 and children[0].type == 'text'
        endTag " #{stringLiteral children[0].data}"
      else
        endTag ' ->'
        @nest => @visitArray children
    else
      endTag()

  visitText: (text) ->
    return if text.data.match /^\s*$/
    @emit "text #{stringLiteral text.data}"

  visitDirective: (directive) ->
    if directive.name.toLowerCase() == '!doctype'
      @emit "doctype TODO" #TODO: Extract doctype
    else
      console.error "Unknown directive: #{inspect directive.name}"

  visitComment: (comment) ->
    @emit "comment #{stringLiteral comment.data}"

  visitScript: (script) ->
    @visitTag script #TODO: Something better

  visitStyle: (style) ->
    @visitTag style #TODO: Something better


html = readFileSync process.argv[2], 'utf8'
new Converter().convert(html)
