Workflow = require './workflow'
Place = require './place'
PlaceView = require './place-view'
d3 = require 'd3'

module.exports =
class WorkflowView
  workflow: null
  dc: null
  elements: {}

  constructor: (@workflow, @dc) ->
    if @workflow.isEmpty()
      start = new Place(start: true, x: 20, y: 100)
      finish = new Place(finish: true, x: 200, y: 100)
      @workflow.addPlace(start)
      @workflow.addPlace(finish)

    @dragging = false
    @draggingNode = null
    @drag = d3.behavior.drag()
      .on("drag", @onDrag)
      .on("dragstart", @onDragStart)
      .on("dragend", @onDragEnd)
    @dc.call(@drag)

  draw: ->
    @drawPlace(place) for place in @workflow.places

  drawPlace: (place) ->
    view = new PlaceView(place, @dc)
    @elements[place.guid] = view
    view.draw()

  addNewPlace: ->
    place = new Place(x: 50, y: 50)
    @autoreposition(place) while @overlaps(place)
    @workflow.addPlace(place)
    @drawPlace(place)

  autoreposition: (node) ->
    node.x += 50
    node.y += 50

  overlaps: (node) ->
    for place in @workflow.places
      return true if node.x == place.x && node.y == place.y
    false

  onDragStart: (node) =>
    @dragging = true
    @draggingNode = @elements[d3.event.sourceEvent.srcElement.id]
    d3.event.sourceEvent.stopPropagation()

  onDragEnd: (node) =>
    @dragging = false
    @draggingNode = null

  onDrag: (node) =>
    @draggingNode.shift(d3.event.dx, d3.event.dy)
