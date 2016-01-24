module.exports =
class NodeView
  dc: null
  node: null
  guid: null

  constructor: (@node, @dc) ->
    @guid = @node.guid

  draw: ->
    ;
