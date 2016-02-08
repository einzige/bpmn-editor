{TextEditor} = require 'atom'
ElementFieldEditorView = require './element-field-editor-view'

module.exports =
class ElementTitleEditorView extends ElementFieldEditorView
  label: -> "Title"

  buildEditorView: ->
    @title = new TextEditor(mini: true, placeholderText: 'Element title')
    @title.onDidChange(@changed)
    atom.views.getView(@title)

  pullData: =>
    #@title.setText(@element.title())

  bindedData: ->
    {title: @title.getText()}
