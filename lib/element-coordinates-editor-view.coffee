{$} = require 'atom-space-pen-views'
{TextEditor} = require 'atom'
ElementFieldEditorView = require './element-field-editor-view'

module.exports =
class ElementCoordinatesEditorView extends ElementFieldEditorView
  label: -> "Coordinates"

  buildEditorView: ->
    @x = new TextEditor(mini: true, placeholderText: 'x')
    @x.onDidChange(@changed)
    @y = new TextEditor(mini: true, placeholderText: 'y')
    @y.onDidChange(@changed)

    wrapper = $('<div />')
    wrapper.append(@x)
    wrapper.append(@y)
    wrapper.append(atom.views.getView(@x))
    wrapper.append(atom.views.getView(@y))
    wrapper

  pullData: =>
    @x.setText("#{@element.x()}")
    @y.setText("#{@element.y()}")

  bindedData: ->
    x = parseInt(@x.getText()) || @element.x()
    y = parseInt(@y.getText()) || @element.y()
    {x: x, y: y}
