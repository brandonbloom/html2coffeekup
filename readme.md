Not fully complete, but still a huge time saver. Tested on dozens of files that only needed minor touch ups after conversion.

# Installation

```
npm install -g html2coffeekup
```

# Command Line Usage

```
html2coffeekup test/simple.html
```

# Example Output (for above usage)

```
doctype TODO
html ->
  head ->
    title 'A simple test page'
    style type: 'text/css', '.foo {\n        color: red\n      }'
  body class: 'awesome', ->
    div id: 'root', class: 'special', ->
      comment 'This page is rapidly becoming not-so-simple'
      h1 'A simple test page'
      p ->
        text 'With some awesome text, and a'
        a href: 'http://www.google.com', 'link'
        text '.'
      p id: 'paragraph_2', ->
        text 'And here is an image:'
        img src: 'fake/source', title: 'not really'
        text 'As well as a disabled select:'
        select disabled: 'disabled', ->
          option 'Oh boy!'
      script type: 'text/javascript', 'console.log("Hello there");\n        console.log("How\'s it going?");
```

# Public API

`convert(html, stream, [callback])`

`html` currently must be a string.

`stream` is a "Writable Stream"

`callback` is optional and passed `(error)` if something goes wrong.

# Example REPL Session

```
coffee> {convert} = require('html2coffeekup')
{ convert: [Function] }
coffee> convert '<a href="http://www.github.com">Github</a>', process.stdout, -> console.log 'done!'
a href: 'http://www.github.com', 'Github'
done!
```
