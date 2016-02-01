d3 = require 'd3'

module.exports =
class MouseHandler

  constructor: (@dc) ->
    @startDragCallbacks = []
    @startShiftDragCallbacks = []
    @startCtrlDragCallbacks = []
    @startAnyDragCallbacks = []

    @endDragCallbacks = []
    @endCtrlDragCallbacks = []
    @endShiftDragCallbacks = []
    @endAnyDragCallbacks = []

    @dragCallbacks = []
    @ctrlDragCallbacks = []
    @shiftDragCallbacks = []
    @anyDragCallbacks = []

    @mouseoverCallbacks = []
    @ctrlMouseoverCallbacks = []
    @shiftMouseoverCallbacks = []
    @anyMouseoverCallbacks = []

    @mouseoutCallbacks = []
    @ctrlMouseoutCallbacks = []
    @shiftMouseoutCallbacks = []
    @anyMouseoutCallbacks = []

    @draggingNode = null
    @drag = d3.behavior.drag().on("drag", @dragHandler)
                              .on("dragstart", @dragStartHandler)
                              .on("dragend", @dragEndHandler)
    if @dc
      @trackDrag(@dc)
      @trackMouseMovements(@dc)

  trackDrag: (svg) ->
    svg.call(@drag)

  trackMouseMovements: (svg) ->
    svg.on("mouseover", @mouseOverHandler).on("mouseout", @mouseOutHandler)

  onStartDrag: (callback) -> @startDragCallbacks.push(callback)
  onStartCtrlDrag: (callback) -> @startCtrlDragCallbacks.push(callback)
  onStartShiftDrag: (callback) -> @startShiftDragCallbacks.push(callback)
  onStartAnyDrag: (callback) -> @startAnyDragCallbacks.push(callback)

  onStartDrag: (callback) -> @startDragCallbacks.push(callback)
  onEndDrag: (callback) -> @endDragCallbacks.push(callback)
  onCtrlEndDrag: (callback) -> @endCtrlDragCallbacks.push(callback)
  onShiftEndDrag: (callback) -> @endShiftDragCallbacks.push(callback)
  onEndAnyDrag: (callback) -> @endAnyDragCallbacks.push(callback)

  onDrag: (callback) -> @dragCallbacks.push(callback)
  onCtrlDrag: (callback) -> @ctrlDragCallbacks.push(callback)
  onShiftDrag: (callback) -> @shiftDragCallbacks.push(callback)
  onAnyDrag: (callback) -> @anyDragCallbacks.push(callback)

  onMouseOver: (callback) -> @mouseoverCallbacks.push(callback)
  onCtrlMouseOver: (callback) -> @ctrlMouseoverCallbacks.push(callback)
  onShiftMouseOver: (callback) -> @shiftMouseoverCallbacks.push(callback)
  onAnyMouseOver: (callback) -> @anyMouseoverCallbacks.push(callback)

  onMouseOut: (callback) -> @mouseoutCallbacks.push(callback)
  onCtrlMouseOut: (callback) -> @ctrlMouseoutCallbacks.push(callback)
  onShiftMouseOut: (callback) -> @shiftMouseoutCallbacks.push(callback)
  onAnyMouseOut: (callback) -> @anyMouseoutCallbacks.push(callback)

  dragStart: (x, y) ->
    callbacks = switch @mode
      when 'ctrl-drag' then @startCtrlDragCallbacks
      when 'shift-drag' then  @startShiftDragCallbacks
      when 'default-drag' then @startDragCallbacks
    return unless callbacks

    @callback(callbacks, @draggingNode, x, y)
    @callback(@startAnyDragCallbacks, @draggingNode, x, y)

  dragEnd: ->
    callbacks = switch @mode
      when 'ctrl-drag' then @endCtrlDragCallbacks
      when 'shift-drag' then  @endShiftDragCallbacks
      when 'default-drag' then @endDragCallbacks
    return unless callbacks

    @callback(callbacks, @draggingNode)
    @callback(@endAnyDragCallbacks, @draggingNode)

  move: (dx, dy) ->
    callbacks = switch @mode
      when 'ctrl-drag' then @ctrlDragCallbacks
      when 'shift-drag' then  @shiftDragCallbacks
      when 'default-drag' then @dragCallbacks
    return unless callbacks

    @callback(callbacks, @draggingNode, dx, dy)
    @callback(@anyDragCallbacks, @draggingNode, dx, dy)

  mouseOver: (targetNode) ->
    callbacks = switch @mode
      when 'ctrl-drag' then @ctrlMouseoverCallbacks
      when 'shift-drag' then  @shiftMouseoverCallbacks
      when 'default-drag' then @mouseoverCallbacks
    return unless callbacks

    @callback(callbacks, targetNode)
    @callback(@anyMouseoverCallbacks, targetNode)

  mouseOut: (targetNode) ->
    callbacks = switch @mode
      when 'ctrl-drag' then @ctrlMouseoutCallbacks
      when 'shift-drag' then  @shiftMouseoutCallbacks
      when 'default-drag' then @mouseoutCallbacks
    return unless callbacks

    @callback(callbacks, targetNode)
    @callback(@anyMouseoutCallbacks, targetNode)

  dragStartHandler: =>
    e = d3.event.sourceEvent

    @draggingNode = @findDomHandler(e.srcElement)
    return unless @draggingNode

    if d3.event.sourceEvent.ctrlKey
      @mode = 'ctrl-drag'
    else if d3.event.sourceEvent.shiftKey
      @mode = 'shift-drag'
    else
      @mode = 'default-drag'

    @dragStart(e.offsetX, e.offsetY)
    d3.event.sourceEvent.stopPropagation()

  dragEndHandler: =>
    @dragEnd(@draggingNode)
    @draggingNode = null
    @mode = null

  dragHandler: =>
    @move(d3.event.dx, d3.event.dy) if @draggingNode

  mouseOverHandler: =>
    if target = @findDomHandler(d3.event.target)
      @mouseOver(target)

  mouseOutHandler: =>
    if target = @findDomHandler(d3.event.target)
      @mouseOut(target)

  callback: (callbacks) ->
    args = Array.prototype.slice.call(arguments, 1);
    callback.apply(null, args) for callback in callbacks

  findDomHandler: (draggable) ->
    while !draggable.id
      break unless draggable.parentNode
      break if draggable == @dc
      draggable = draggable.parentNode

    if draggable?.id then draggable
