Place = require './place'
Transition = require './transition'
PlaceView = require './place-view'
TransitionView = require './transition-view'
FakeNode = require './fake-node'
FakeNodeView = require './fake-node-view'

module.exports =
class ArcCreator
  sourceNode: null # NodeView
  targetNode: null # NodeView

  constructor: (@dc) ->
    ;

  startDrag: (node, x, y) ->
    @startFrom(node)
    @x = x
    @y = y

  shift: (dx, dy) ->
    @x = @x + dx
    @y = @y + dy

  startFrom: (sourceNode) ->
    @sourceNode = sourceNode

  moveTargetNode: (x, y) ->
    if !@targetNode
      @createDraftNode(x, y)

    @targetNode.move(x, y)

  shiftTargetNode: (dx, dy) ->
    @shift(dx, dy)
    @createDraftNode() unless @targetNode
    @targetNode.shift(dx, dy)

  shiftConnection: (dx, dy) ->
    @shift(dx, dy)
    @createFakeNode() unless @targetNode

    if @targetNode instanceof FakeNodeView
      @targetNode.shift(dx, dy)

  reset: ->
    if @targetNode instanceof FakeNodeView
      @arc.detach() if @arc

    @targetNode = null
    @sourceNode = null
    @arc = null

  detachDraft: ->
    @targetNode.detach() if @targetNode
    @arc.detach() if @arc
    @reset()

  connectTo: (node) ->
    return if @targetNode == node or @sourceNode == node
    @arc.detach() if @arc
    @targetNode = node
    @arc = @sourceNode.connectTo(node, draft: true)

  disconnectFrom: (node) ->
    return if @targetNode != node
    @arc.detach() if @arc
    @targetNode = null
    @arc = null

  createDraftNode: (x, y) ->
    x or= @x
    y or= @y

    if @sourceNode instanceof PlaceView
      @createDraftTransition(x, y)
    else
      @createDraftPlace(x, y)

  createDraftTransition: (x, y) ->
    node = new Transition(x: x, y: y, workflow: @sourceNode.workflow)
    view = new TransitionView(node, @dc, draft: true)
    @targetNode = view.attachDraft()
    @arc = @sourceNode.connectTo(@targetNode)

  createFakeNode: ->
    node = new FakeNode(x: @x, y: @y, workflow: @sourceNode.workflow)
    @targetNode = new FakeNodeView(node, @dc, draft: true)
    @targetNode.attach()
    @arc = @sourceNode.connectTo(@targetNode)

  createDraftPlace: (x, y) ->
    node = new Place(x: x, y: y, workflow: @sourceNode.workflow)
    view = new PlaceView(node, @dc, draft: true)
    @targetNode = view.attachDraft()
    @arc = @sourceNode.connectTo(@targetNode)

  createdElementViews: ->
    result = []
    unless @targetNode instanceof FakeNodeView
      result.push(@targetNode) if @targetNode?.draft
      result.push(@arc) if @arc
    result
