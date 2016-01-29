ElementView = require './element-view'
Arc = require './arc'
ArcView = require './arc-view'
_ = require 'underscore-plus'

module.exports =
class NodeView extends ElementView

  constructor: (@element, @dc, {draft} = {draft: false}) ->
    super
    @arcs = []

  x: ->
    @element.x

  y: ->
    @element.y

  top: -> ;
  topLeft: -> ;
  topRight: -> ;
  left: -> ;
  right: -> ;
  bottomLeft: -> ;
  bottom: -> ;
  bottomRight: -> ;

  setPosition: (x, y) ->
    @view.attr('x', x)
    @view.attr('y', y)
    @

  move: (x, y) ->
    @element.x = Math.round(x)
    @element.y = Math.round(y)
    @setPosition(@element.x, @element.y)
    @redrawArcs()
    @

  shift: (dx, dy) ->
    x = @element.x + dx
    y = @element.y + dy
    @move(x, y)
    @

  detach: ->
    super
    arc.detach() for arc in @arcs

  attachArc: (arc) ->
    for a in @arcs
      return if a.guid == arc.guid
    @arcs.push(arc)

  detachArc: (arc) ->
    @arcs = _.reject(@arcs, (a) -> a.guid == arc.guid)

  connectTo: (node) ->
    arc = new Arc(from: @element, to: node.element, workflow: @workflow)
    arcView = new ArcView(arc, @dc, draft: node.draft, fromView: @, toView: node)
    arcView.attach()

  redrawArcs: ->
    arc.redraw() for arc in @arcs
