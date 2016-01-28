module.exports =
class ElementView

  constructor: (@element, @dc, {draft} = {draft: false}) ->
    @guid = @element.guid
    @draft = draft

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

  setPosition: (x, y) ->
    @view.attr('x', x)
    @view.attr('y', y)
    @

  toDraft: ->
    @draft = true
    @view.attr('fill-opacity', 0.3)
    @view.attr('stroke-dasharray', '5, 5')
    @

  fromDraft: ->
    draft = false
    @view.attr('fill-opacity', 1.0)
    @view.attr('stroke-dasharray', null)
    @
