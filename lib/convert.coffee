{inspect} = require 'util'
htmlparser = require 'htmlparser'


stringLiteral = (html) ->
  inspect html.trim()


exports.convert = (html) ->

  depth = 0

  emit = (code) ->
    console.log Array(depth + 1).join('  ') + code

  nest = (callback) ->
    depth++
    result = callback()
    depth--
    result

  visit =

    node: (node) ->
      visit[node.type](node)

    array: (array) ->
      for node in array
        visit.node node

    tag: (tag) ->
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
        emit code
      if (children = tag.children)?
        if children.length == 1 and children[0].type == 'text'
          endTag " #{stringLiteral children[0].data}"
        else
          endTag ' ->'
          nest -> visit.array children
      else
        endTag()

    text: (text) ->
      return if text.data.match /^\s*$/
      emit "text #{stringLiteral text.data}"

    directive: (directive) ->
      if directive.name.toLowerCase() == '!doctype'
        emit "doctype TODO" #TODO: Extract doctype
      else
        console.error "Unknown directive: #{inspect directive.name}"

    comment: (comment) ->
      emit "comment #{stringLiteral comment.data}"

    script: (script) ->
      visit.tag script #TODO: Something better

    style: (style) ->
      visit.tag style #TODO: Something better

  handler = new htmlparser.DefaultHandler (err, dom) =>
    throw err if err
    visit.array dom
  parser = new htmlparser.Parser(handler)
  parser.parseComplete(html)
