Workflow = require './workflow'
Place = require './place'
PlaceView = require './place-view'
d3 = require 'd3'

module.exports =
class WorkflowView
  workflow: null
  elements: {}
  zoomFactor: 0.08
  minZoomLevel: 0.3
  maxZoomLevel: 8

  constructor: (@workflow, @svg) ->
    # Set up drawing context
    @dc = @svg.append("g")

    # Set up zoom and panning
    @zoom = d3.behavior.zoom()
      .scaleExtent([@minZoomLevel, @maxZoomLevel])
      .on("zoom", @zoomed)
    @svg.call(@zoom)

    # Set up dragging
    @dragging = false
    @draggingNode = null
    @drag = d3.behavior.drag()
      .on("drag", @onDrag)
      .on("dragstart", @onDragStart)
      .on("dragend", @onDragEnd)
    @dc.call(@drag)

    # Fill the interface with start and finish nodes if both are not present
    if @workflow.isEmpty()
      start = new Place(start: true, x: 20, y: 100)
      finish = new Place(finish: true, x: 200, y: 100)
      @workflow.addPlace(start)
      @workflow.addPlace(finish)

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
    @draggingNode.shift(d3.event.dx / @zoom.scale(), d3.event.dy / @zoom.scale())

  zoomed: =>
    @dc.attr("transform", "translate(" + @zoom.translate() + ")scale(" + @zoom.scale() + ")")

  zoomOut: =>
    @zoom.scale(@zoom.scale() * (1 - @zoomFactor))
    @zoomed()

  zoomIn: =>
    @zoom.scale(@zoom.scale() * (1 + @zoomFactor))
    @zoomed()
