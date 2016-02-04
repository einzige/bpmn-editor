Workflow = require './workflow'
Place = require './place'
PlaceView = require './place-view'
Transition = require './transition'
TransitionView = require './transition-view'
Arc = require './arc'
ArcCreator = require './arc-creator'
MouseSelectionHandler = require './mouse-selection-handler'
d3 = require 'd3'

module.exports =
class WorkflowView
  zoomFactor: 0.08
  minZoomLevel: 0.3
  maxZoomLevel: 8

  constructor: (@workflow, @svg) ->
    @elements = {}

    # Set up drawing context
    @dc = @svg.append("g")

    # Set up zoom and panning
    @zoom = d3.behavior.zoom().scaleExtent([@minZoomLevel, @maxZoomLevel]).on("zoom", @zoomed)
    @svg.call(@zoom)

    @arcCreator = new ArcCreator(@dc)

    @mouseSelectionHandler = new MouseSelectionHandler(@dc)
    @mouseSelectionHandler.onStartAnyDrag(@onStartDrag)
    @mouseSelectionHandler.onEndAnyDrag(@onEndDrag)
    @mouseSelectionHandler.onDrag(@onDrag)
    @mouseSelectionHandler.onCtrlDrag(@onCtrlDrag)
    @mouseSelectionHandler.onShiftDrag(@onShiftDrag)
    @mouseSelectionHandler.onCtrlMouseOver(@onCtrlMouseOver)
    @mouseSelectionHandler.onCtrlMouseOut(@onCtrlMouseOut)
    @mouseSelectionHandler.onClick(@onClickNode)

    @svg.on('click', @onMouseClick)
    @svg.on('mousemove', @onMouseMove)

    @workflow.onNewElement(@addNewDraftNode)
    @workflow.onElementsAdded(@addNewNodes)
    @workflow.onElementsRemoved(@removeNodes)

    # Fill the interface with start and finish nodes if both are not present
    if @workflow.isEmpty()
      start = new Place(start: true, x: 20, y: 100)
      finish = new Place(finish: true, x: 200, y: 100)
      @workflow.addElement(start)
      @workflow.addElement(finish)

  addNewDraftNode: (node) =>
    @newNode.detach() if @newNode
    @newNode = node.createView(@dc, draft: true)
    @newNode.attach()
    @newNode

  addNewNodes: (newNodes) =>
    for node in newNodes
      @attachNode(node)

  removeNodes: (nodes) =>
    for node in nodes
      @detachNode(node)

  attachNode: (node) ->
    existing = @elements[node.guid]
    return existing if existing

    view = node.createView(@dc)

    if node instanceof Arc
      fromView = @elements[node.fromNode.guid]
      toView = @elements[node.toNode.guid]
      view.connect(fromView, toView)
      view.attach()
    else
      view.attach()

    @elements[node.guid] = view

  detachNode: (node) ->
    nodeView = @elements[node.guid]

    if nodeView
      nodeView.detach()
      delete @elements[node.guid]

  onStartDrag: (domNode, x, y) =>
    node = @elements[domNode.id]
    return unless node

    [dx, dy] = @zoom.translate()
    @arcCreator.startDrag(node, (x - dx) / @zoom.scale(), (y - dy) / @zoom.scale())

  onEndDrag: =>
    @workflow.addElement(element) for element in @arcCreator.createdElements()
    #console.log(@arcCreator.createdElements())
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

  onMouseMove: =>
    event = d3.event

    if @newNode
      [dx, dy] = @zoom.translate()
      @newNode.move((event.offsetX - dx) / @zoom.scale(), (event.offsetY - dy) / @zoom.scale())

  onMouseClick: =>
    if @newNode
      @workflow.addElement(@newNode.element)
      @newNode.detach()
      @newNode = null

  onClickNode: (domNode) =>
    node = @elements[domNode.id]
    return unless node

    console.log(node)

    d3.event.stopPropagation()

  zoomed: =>
    @dc.attr("transform", "translate(" + @zoom.translate() + ")scale(" + @zoom.scale() + ")")

  zoomOut: =>
    @zoom.scale(@zoom.scale() * (1 - @zoomFactor))
    @zoomed()

  zoomIn: =>
    @zoom.scale(@zoom.scale() * (1 + @zoomFactor))
    @zoomed()
