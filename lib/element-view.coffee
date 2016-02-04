module.exports =
class ElementView

  constructor: (@element, @dc, {@draft} = {draft: false}) ->
    @guid = @element.guid
    @selected = false

  strokeColor: -> if @selected then 'orange' else 'lightgray'
  strokeWidth: -> 2
  fillColor: -> @element.color
  fillOpacity: -> if @draft then 0.3 else 1.0
  strokeDasharray: -> if @draft then '5, 5' else null

  selectionTarget: ->
    @view

  primitive: ->
    @view

  attach: ->
    @redraw() if @view
    @selectionTarget().attr('id', @guid)
    @

  detach: ->
    if @view
      @view.remove()
      @view = null
    @

  redraw: ->
    @attach() unless @view
    @primitive().attr('stroke', @strokeColor())
                      .attr("fill", @fillColor())
                      .attr('fill-opacity', @fillOpacity())
                      .attr('stroke-width', @strokeWidth())
                      .attr('stroke-dasharray', @strokeDasharray())

  toSelected: ->
    @selected = true
    @redraw()

  toDraft: ->
    @draft = true
    @redraw()
    @
