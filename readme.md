Barely functional and not pretty to use, but here it is in action.

# Usage

```
$ coffee html2coffeekup.coffee test/simple.html
```

# Output

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
