ElementView = require './element-view'
Arc = require './arc'
ArcView = require './arc-view'

module.exports =
class NodeView extends ElementView
  arcs: {}

  x: ->
    @element.x

  y: ->
    @element.y

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
    @arcs[arc.guid] = arc

  detachArc: (arc) ->
    delete @arcs[arc.guid]

  connectTo: (node, {draft} = {draft: false}) ->
    arc = new Arc(from: @element, to: node.element, workflow: @workflow)
    arcView = new ArcView(arc, @dc, draft: draft, fromView: @, toView: node)
    arcView.attach()

  redrawArcs: ->
    console.log(@arcs)
    for arc in @arcs
      console.log(arc)
      arc.redraw()
