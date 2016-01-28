ElementView = require './element-view'

module.exports =
class NodeView extends ElementView
  x: ->
    @element.x

  y: ->
    @element.y

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
    @element.x = Math.round(x)
    @element.y = Math.round(y)
    @setPosition(@element.x, @element.y)
    @

  shift: (dx, dy) ->
    x = @element.x + dx
    y = @element.y + dy
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
