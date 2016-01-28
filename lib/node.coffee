crypto = require('crypto')
Element = require('./element')
NodeView = require('./node-view')

module.exports =
class Node extends Element

  constructor: ({x, y, title, color, workflow} = {}) ->
    @x = if x then x else 0
    @y = if y then y else 0
    super

  createView: (dc) ->
    new NodeView(@, dc)
