{$, ScrollView} = require 'atom-space-pen-views'

module.exports =
class AttributeEditorView extends ScrollView
  initialize: (attributeEditor) ->
    super
    @attributeEditor = attributeEditor
    @attributeEditor.onDidChangeVisibility(@update)

  @content: ->
    @div class: 'tool-panel', =>
      @div class: 'padded', =>
        @div class: 'inset-panel', =>
          @div class: 'panel-heading', =>
            @span class: 'icon icon-list-unordered', "Attribute Editor"
          @div class: 'panel-body padded', 'Please select a node in the graph editor'

  attach: ->
    atom.workspace.addRightPanel(item: @)
    @hide() if @attributeEditor.hidden()

  update: =>
    if @attributeEditor.hidden() then @hide() else @show()
