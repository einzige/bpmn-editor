ElementView = require './element-view'
Arc = require './arc'
ArcView = require './arc-view'
_ = require 'underscore-plus'

module.exports =
class NodeView extends ElementView

  constructor: (@element, @dc, {draft} = {draft: false}) ->
    super
    @arcs = []

  detach: ->
    super
    # arc.detach() for arc in @arcs

  remove: ->
    super
    arc.remove() for arc in @arcs

  move: (x, y) ->
    @change(x: Math.round(x), y: Math.round(y))
    @

  shift: (dx, dy) ->
    x = @element.x + dx
    y = @element.y + dy
    @move(x, y)
    @

  redraw: ->
    super
    @setPosition(@x(), @y())
    @redrawArcs()

  x: -> @element.x
  y: -> @element.y
  centerX: -> @x()
  centerY: -> @y()

  top: -> ;
  topLeft: -> ;
  topRight: -> ;
  left: -> ;
  right: -> ;
  bottomLeft: -> ;
  bottom: -> ;
  bottomRight: -> ;

  setPosition: (x, y) ->
    if @view
      @view.attr('transform', "translate(#{x}, #{y})")
    @

  attachArc: (arc) ->
    for a in @arcs
      return if a.guid == arc.guid && a.draft == arc.draft
    @arcs.push(arc)

  detachArc: (arc) ->
    @arcs = _.reject(@arcs, (a) -> a.guid == arc.guid && a.draft == arc.draft)

  redrawArcs: ->
    arc.redraw() for arc in @arcs

  connectedTo: (node) ->
    for arc in @arcs
      if !arc.draft && arc.toView.guid == node.guid
        return true
    return false
