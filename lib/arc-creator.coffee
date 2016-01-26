Place = require './place'
Transition = require './transition'
PlaceView = require './place-view'
TransitionView = require './transition-view'

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

  detachDraft: ->
    @targetNode.detach() if @targetNode
    @targetNode = null
    @sourceNode = null

  createDraftNode: (x, y) ->
    if @sourceNode instanceof PlaceView
      @createDraftTransition(x, y)
    else
      @createDraftPlace(x, y)

  createDraftTransition: (x, y) ->
    node = new Transition(x: x, y: y)
    view = new TransitionView(node, @dc, {draft: true})
    @targetNode = view
    @targetNode.draw()
    @targetNode.toDraft()
    @targetNode

  createDraftPlace: (x, y) ->
    node = new Place(x: x, y: y)
    view = new PlaceView(node, @dc, {draft: true})
    @targetNode = view
    @targetNode.draw()
    @targetNode.toDraft()
    @targetNode
