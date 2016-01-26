module.exports =
class NodeView
  dc: null
  node: null
  guid: null

  constructor: (@node, @dc) ->
    @guid = @node.guid

  draw: ->
    ;

  setPosition: (x, y) ->
    @view.attr('x', x)
    @view.attr('y', y)

  move: (x, y) ->
    @node.x = Math.round(x)
    @node.y = Math.round(y)
    @setPosition(@node.x, @node.y)

  shift: (dx, dy) ->
    x = @node.x + dx
    y = @node.y + dy
    @move(x, y)
