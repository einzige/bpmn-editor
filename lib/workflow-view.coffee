Workflow = require './workflow'
Place = require './place'
PlaceView = require './place-view'
Transition = require './transition'
TransitionView = require './transition-view'
ArcCreator = require './arc-creator'
d3 = require 'd3'

module.exports =
class WorkflowView
  zoomFactor: 0.08
  minZoomLevel: 0.3
  maxZoomLevel: 8

  constructor: (@workflow, @svg) ->
    @elements = {} # TODO: must be an array

    # Set up drawing context
    @dc = @svg.append("g")

    # Set up zoom and panning
    @zoom = d3.behavior.zoom().scaleExtent([@minZoomLevel, @maxZoomLevel]).on("zoom", @zoomed)
    @svg.call(@zoom)

    # Set up dragging
    @dragging = false
    @draggingNode = null
    @drag = d3.behavior.drag().on("drag", @onDrag).on("dragstart", @onDragStart).on("dragend", @onDragEnd)
    @dc.call(@drag)

    @arcCreator = new ArcCreator(@dc)

    # Fill the interface with start and finish nodes if both are not present
    if @workflow.isEmpty()
      start = new Place(start: true, x: 20, y: 100)
      finish = new Place(finish: true, x: 200, y: 100)
      @workflow.addPlace(start)
      @workflow.addPlace(finish)

    # Draw the net
    @eachNode (node) =>
      @attachNode(node)

  addElementView: (view) ->
    @elements[view.guid] = view
    @workflow.addElement(view.element)
    view.fromDraft()
    #view.attach()

  attachNode: (node) ->
    view = node.createView(@dc)
    @elements[node.guid] = view
    view.attach()

  attachNewNode: (nodeClass) ->
    node = new nodeClass(x: 50, y: 50)
    @autoreposition(node) while @overlaps(node)
    @workflow.addElement(node)
    @attachNode(node)

  attachNewPlace: ->
    @attachNewNode(Place)

  attachNewTransition: ->
    @attachNewNode(Transition)

  eachNode: (callback) ->
    callback(node) for node in @workflow.places
    callback(node) for node in @workflow.transitions

  autoreposition: (node) ->
    node.x += 50
    node.y += 50

  overlaps: (node) ->
    for n in @workflow.places
      return true if node.x == n.x && node.y == n.y

    for n in @workflow.transitions
      return true if node.x == n.x && node.y == n.y

    false

  onDragStart: (node) =>
    @dragging = true
    @draggingNode = null

    draggable = d3.event.sourceEvent.srcElement

    while !@elements[draggable.id]
      break unless draggable.parentNode
      draggable = draggable.parentNode

    @draggingNode = @elements[draggable.id]
    @arcCreator.sourceNode = @draggingNode

    if @draggingNode
      if d3.event.sourceEvent.shiftKey
        @mode = 'new-arc'
      else
        @mode = 'move'

      d3.event.sourceEvent.stopPropagation()

  onDragEnd: (node) =>
    @dragging = false
    @draggingNode = null

    @addElementView(view) for view in @arcCreator.createdElementViews()
    @arcCreator.reset()

    @mode = null

  onDrag: (node) =>
    switch @mode
      when 'move' then @move()
      when 'new-arc' then @dragNewArc()

  dragDx: ->
    d3.event.dx / @zoom.scale()

  dragDy: ->
    d3.event.dy / @zoom.scale()

  move: ->
    @draggingNode.shift(@dragDx(), @dragDy())

  dragNewArc: ->
    @arcCreator.shiftTargetNode(@dragDx(), @dragDy())

  zoomed: =>
    @dc.attr("transform", "translate(" + @zoom.translate() + ")scale(" + @zoom.scale() + ")")

  zoomOut: =>
    @zoom.scale(@zoom.scale() * (1 - @zoomFactor))
    @zoomed()

  zoomIn: =>
    @zoom.scale(@zoom.scale() * (1 + @zoomFactor))
    @zoomed()
