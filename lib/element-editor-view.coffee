{$, ScrollView} = require 'atom-space-pen-views'
ElementTitleEditorView = require './element-title-editor-view'
ElementCoordinatesEditorView = require './element-coordinates-editor-view'

module.exports =
class ElementEditorView extends ScrollView
  initialize: (element) ->
    @element = element

  attached: ->
    @titleEditor = new ElementTitleEditorView()
    @titleEditor.initialize(@element)
    @container.append(@titleEditor)

    @coordinatesEditor = new ElementCoordinatesEditorView()
    @coordinatesEditor.initialize(@element)
    @container.append(@coordinatesEditor)

  @content: ->
    @div class: 'block', =>
      @div outlet: 'container'
