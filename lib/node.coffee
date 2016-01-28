crypto = require('crypto')
Element = require('./element')
NodeView = require('./node-view')

module.exports =
class Node extends Element
  x: 0
  y: 0

  constructor: ({x, y, title, color, workflow} = {}) ->
    @x = x if x
    @y = y if y
    super

  createView: (dc) ->
    new NodeView(@, dc)
