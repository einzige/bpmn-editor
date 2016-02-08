ElementEditorView = require './element-editor-view'
ElementTitleEditorView = require './element-title-editor-view'
ElementCoordinatesEditorView = require './element-coordinates-editor-view'

module.exports =
class NodeEditorView extends ElementEditorView
  attached: ->
    @titleEditor = new ElementTitleEditorView()
    @titleEditor.initialize(@element)
    @container.append(@titleEditor)

    @coordinatesEditor = new ElementCoordinatesEditorView()
    @coordinatesEditor.initialize(@element)
    @container.append(@coordinatesEditor)
