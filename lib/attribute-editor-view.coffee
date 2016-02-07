{$, ScrollView} = require 'atom-space-pen-views'
PlaceEditorView = require './place-editor-view'

module.exports =
class AttributeEditorView extends ScrollView
  initialize: (attributeEditor) ->
    super
    @attributeEditor = attributeEditor
    @attributeEditor.onDidChangeVisibility(@update)
    @selectionHandler = attributeEditor.selectionHandler

    if @selectionHandler
      @selectionHandler.onSingleElementSelected(@displayElementEditor)
      @selectionHandler.onSelectionCleared(@reset)
      @selectionHandler.onMultipleElementsSelected(@displayElementsChoiceList)

    @reset()

  reset: =>
    @title.text('Attribute Editor - nothing selected')
    @container.text('Please select a node in the graph editor')

  displayElementEditor: (element) =>
    @title.text("Attribute Editor - #{element.constructor.name}")
    @container.text('')
    view = new PlaceEditorView(element)
    @container.append(view)

  displayElementsChoiceList: (elements) =>
    @title.text("Attribute Editor")
    @container.text("Selected #{nodes.length} elements")

  attach: ->
    atom.workspace.addRightPanel(item: @)
    @hide() if @attributeEditor.hidden()

  update: =>
    if @attributeEditor.hidden() then @hide() else @show()

  @content: ->
    @div class: 'tool-panel', =>
      @div class: 'padded', =>
        @div class: 'inset-panel', =>
          @div class: 'panel-heading', =>
            @span class: 'icon icon-list-unordered', outlet: 'title'
          @div class: 'panel-body padded', outlet: 'container'
