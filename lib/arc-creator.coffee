Arc = require './arc'
Place = require './place'
Transition = require './transition'
FakeNode = require './fake-node'

module.exports =
class ArcCreator
  constructor: (@dc) ->
    ;

  startDrag: (node, x, y) ->
    @sourceNode = node
    @x = x
    @y = y

  shift: (dx, dy) ->
    @x = @x + dx
    @y = @y + dy

  shiftTargetNode: (dx, dy) ->
    @shift(dx, dy)
    @createDraftNode() unless @targetNode
    @targetNode.shift(dx, dy)

  shiftConnection: (dx, dy) ->
    @shift(dx, dy)
    @createDraft(FakeNode) unless @targetNode

    if @targetNode.element instanceof FakeNode
      @targetNode.shift(dx, dy)

  connectTo: (node) ->
    return if @targetNode == node or @sourceNode == node
    return if @sourceNode.constructor.name == node.constructor.name
    return if @sourceNode.connectedTo(node)

    @reset(sourceNode: @sourceNode, targetNode:node)
    @createArc()

  disconnectFrom: (node) ->
    return if @targetNode != node
    sourceNode = @sourceNode
    @reset()
    @sourceNode = sourceNode

  createDraftNode: (x = @x, y = @y) ->
    if @sourceNode.element instanceof Place
      @createDraft(Transition, x, y)
    else
      @createDraft(Place, x, y)

  createDraft: (nodeClass, x = @x, y = @y) ->
    node = new nodeClass(x: x, y: y, workflow: @sourceNode.workflow)
    view = node.createView(@dc, draft: true)
    @targetNode = view.attachDraft()
    @createArc()

  createdElements: ->
    result = []
    unless @targetNode?.element instanceof FakeNode
      result.push(@targetNode.element) if @targetNode?.draft
      result.push(@arc.element) if @arc
    result

  reset: ({sourceNode, targetNode} = {sourceNode: null, targetNode: null}) ->
    if @arc
      @sourceNode.detachArc(@arc)
      @targetNode.detachArc(@arc)
      @arc.detach()

    if @targetNode?.draft
      @targetNode.detach()

    @sourceNode = sourceNode
    @targetNode = targetNode
    @arc = null

  createArc: ->
    @connect(@sourceNode, @targetNode)

  connect: (from, to) ->
    arc = new Arc(from: from.element, to: to.element)
    @arc = arc.createView(@dc, draft: true)
    @arc.connect(from, to)
    @arc.attach()
    @arc
