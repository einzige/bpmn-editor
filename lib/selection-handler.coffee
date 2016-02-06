{Emitter} = require 'atom'
ElementView = require './element-view'

module.exports =
class SelectionHandler
  constructor: ->
    @currentSelection = []
    @emitter = new Emitter()

  onSelectionChanged: (callback) ->
    @emitter.on 'selection-changed', callback

  onSingleElementSelected: (callback) ->
    @emitter.on 'single-element-selected', callback

  onMultipleElementsSelected: (callback) ->
    @emitter.on 'multiple-elements-selected', callback

  setSelection: (nodes) ->
    @dehighlightSelection()
    @currentSelection = if nodes instanceof ElementView then [nodes] else nodes
    @highlightSelection()

    @emitter.emit 'selection-changed', @currentSelection

    if @currentSelection.length == 1
      @emitter.emit 'single-element-selected', @currentSelection[0]
    else
      @emitter.emit 'multiple-elements-selected', @currentSelection

  deselectAll: ->
    @setSelection([])

  dehighlightSelection: ->
    node.fromSelected() for node in @currentSelection

  highlightSelection: ->
    node.toSelected() for node in @currentSelection
