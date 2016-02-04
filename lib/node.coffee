crypto = require('crypto')
Element = require('./element')
NodeView = require('./node-view')

module.exports =
class Node extends Element

  constructor: ({@x, @y, title, color, workflow} = {x: 0, y: 0}) ->
    super

  createView: (dc, attributes) ->
    new NodeView(@, dc, attributes)
