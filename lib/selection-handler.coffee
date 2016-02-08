{Emitter} = require 'atom'
ElementView = require './element-view'

module.exports =
class SelectionHandler
  constructor: ->
    @currentSelection = []
    @emitter = new Emitter()

    atom.commands.add '.topnet', 'topnet:delete-element': (event) =>
      element.remove() for element in @currentSelection
      # @deselectAll()
      @currentSelection = []

  onSelectionChanged: (callback) ->
    @emitter.on 'selection-changed', callback

  onSingleElementSelected: (callback) ->
    @emitter.on 'single-element-selected', callback

  onMultipleElementsSelected: (callback) ->
    @emitter.on 'multiple-elements-selected', callback

  onSelectionCleared: (callback) ->
    @emitter.on 'selection-cleared', callback

  setSelection: (nodes) ->
    if nodes instanceof ElementView
      return if @currentSelection.length == 1 && nodes.guid == @currentSelection[0].guid
      @dehighlightSelection()
      @currentSelection = [nodes]
    else
      @dehighlightSelection()
      @currentSelection = nodes

    @highlightSelection()

    @emitter.emit 'selection-changed', @currentSelection

    if @currentSelection.length == 1
      @emitter.emit 'single-element-selected', @currentSelection[0]
    else if @currentSelection.length == 0
      @emitter.emit 'selection-cleared'
    else
      @emitter.emit 'multiple-elements-selected', @currentSelection

  deselectAll: ->
    @setSelection([])

  dehighlightSelection: ->
    node.fromSelected() for node in @currentSelection

  highlightSelection: ->
    node.toSelected() for node in @currentSelection
