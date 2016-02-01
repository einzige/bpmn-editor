Workflow = require './workflow'
Place = require './place'
PlaceView = require './place-view'
Transition = require './transition'
TransitionView = require './transition-view'
ArcCreator = require './arc-creator'
MouseHandler = require './mouse-handler'
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

    @arcCreator = new ArcCreator(@dc)
    @mouseHandler = new MouseHandler(@dc)

    @mouseHandler.onStartAnyDrag(@onStartDrag)
    @mouseHandler.onEndAnyDrag(@onEndDrag)
    @mouseHandler.onDrag(@onDrag)
    @mouseHandler.onCtrlDrag(@onCtrlDrag)
    @mouseHandler.onShiftDrag(@onShiftDrag)
    @mouseHandler.onCtrlMouseOver(@onCtrlMouseOver)
    @mouseHandler.onCtrlMouseOut(@onCtrlMouseOut)

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

  onStartDrag: (domNode, x, y) =>
    node = @elements[domNode.id]
    return unless node

    [dx, dy] = @zoom.translate()
    @arcCreator.startDrag(node, (x - dx) / @zoom.scale(), (y - dy) / @zoom.scale())

  onEndDrag: =>
    @addElementView(view) for view in @arcCreator.createdElementViews()
    @arcCreator.reset()

  onDrag: (domNode, dx, dy) =>
    node = @elements[domNode.id]
    return unless node

    node.shift(dx / @zoom.scale(), dy / @zoom.scale())

  onCtrlDrag: (node, dx, dy) =>
    @arcCreator.shiftConnection(dx / @zoom.scale(), dy / @zoom.scale())

  onShiftDrag: (node, dx, dy) =>
    @arcCreator.shiftTargetNode(dx / @zoom.scale(), dy / @zoom.scale())

  onCtrlMouseOver: (domNode) =>
    node = @elements[domNode.id]
    return unless node

    @arcCreator.connectTo(node)

  onCtrlMouseOut: (domNode) =>
    node = @elements[domNode.id]
    return unless node

    @arcCreator.disconnectFrom(node)

  zoomed: =>
    @dc.attr("transform", "translate(" + @zoom.translate() + ")scale(" + @zoom.scale() + ")")

  zoomOut: =>
    @zoom.scale(@zoom.scale() * (1 - @zoomFactor))
    @zoomed()

  zoomIn: =>
    @zoom.scale(@zoom.scale() * (1 + @zoomFactor))
    @zoomed()

  autoreposition: (node) ->
    node.x += 50
    node.y += 50

  overlaps: (node) ->
    for n in @workflow.places
      return true if node.x == n.x && node.y == n.y

    for n in @workflow.transitions
      return true if node.x == n.x && node.y == n.y

    false
