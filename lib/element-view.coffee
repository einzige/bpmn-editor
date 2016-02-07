{Emitter} = require 'atom'

module.exports =
class ElementView
  selectedColor: 'orange'
  unselectedColor: 'lightgray'

  constructor: (@element, @dc, {@draft} = {draft: false}) ->
    @emitter = new Emitter()
    @guid = @element.guid
    @selected = false

  onChange: (callback) ->
    @emitter.on 'changed', callback

  strokeColor: -> if @selected then @selectedColor else @unselectedColor
  strokeWidth: -> if @selected then 3 else 2
  fillColor: -> @element.color
  fillOpacity: -> if @draft then 0.3 else 1.0
  strokeDasharray: -> if @draft then '5, 5' else null

  title: -> @element.title || ''

  selectionTarget: ->
    @view

  primitive: ->
    @view

  remove: ->
    @element.remove()
    @detach()

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

  fromSelected: ->
    @selected = false
    @redraw()

  toDraft: ->
    @draft = true
    @redraw()
    @

  change: (params = {}) ->
    for k, v of params
      @element[k] = v
    @redraw()
    @emitter.emit 'change', params

  workflow: -> @element.workflow
