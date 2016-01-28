module.exports =
class NodeView
  dc: null
  node: null
  guid: null
  view: null

  constructor: (@node, @dc, {draft} = {draft: false}) ->
    @guid = @node.guid
    @draft = draft

  x: ->
    @node.x

  y: ->
    @node.y

  attach: ->
    @view = null
    @

  attachDraft: ->
    @attach()
    @toDraft()
    @

  detach: ->
    if @view
      @view.remove()
    @

  setPosition: (x, y) ->
    @view.attr('x', x)
    @view.attr('y', y)
    @

  move: (x, y) ->
    @node.x = Math.round(x)
    @node.y = Math.round(y)
    @setPosition(@node.x, @node.y)
    @

  shift: (dx, dy) ->
    x = @node.x + dx
    y = @node.y + dy
    @move(x, y)
    @

  toDraft: ->
    @draft = true
    @view.attr('fill-opacity', 0.3)
    @view.attr('stroke-dasharray', '5, 5')
    @

  fromDraft: ->
    draft = false
    @view.attr('fill-opacity', 1.0)
    @view.attr('stroke-dasharray', null)
    @
