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

  startFrom: (sourceNode) ->
    @sourceNode = sourceNode

  moveTargetNode: (x, y) ->
    if !@targetNode
      @createDraftNode(x, y)

    @targetNode.move(x, y)

  shiftTargetNode: (dx, dy) ->
    if !@targetNode
      @createDraftNode(@sourceNode.x(), @sourceNode.y())
    @targetNode.shift(dx, dy)

  shiftConnection: (dx, dy) ->
    if !@targetNode
      @createFakeNode(@sourceNode.x(), @sourceNode.y())
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

  createDraftNode: (x, y) ->
    if @sourceNode instanceof PlaceView
      @createDraftTransition(x, y)
    else
      @createDraftPlace(x, y)

  createDraftTransition: (x, y) ->
    node = new Transition(x: x, y: y, workflow: @sourceNode.workflow)
    view = new TransitionView(node, @dc, draft: true)
    @targetNode = view.attachDraft()
    @arc = @sourceNode.connectTo(@targetNode)

  createFakeNode: (x, y) ->
    node = new FakeNode(x: x, y: y, workflow: @sourceNode.workflow)
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
      if @targetNode?.draft && @arc
        result.push(@targetNode)
        result.push(@arc)
    result
