module.exports =
class ElementView

  constructor: (@element, @dc, {@draft} = {draft: false}) ->
    @guid = @element.guid

  attach: ->
    @view = null
    @

  attachDraft: ->
    @attach()
    @toDraft()
    @

  detach: ->
    if @view
      @view.remove()
      @view = null
    @

  toDraft: ->
    @draft = true
    if @view
      @view.attr('fill-opacity', 0.3)
      @view.attr('stroke-dasharray', '5, 5')
    @

  fromDraft: ->
    draft = false
    if @view
      @view.attr('fill-opacity', 1.0)
      @view.attr('stroke-dasharray', null)
    @
