{$, ScrollView} = require 'atom-space-pen-views'
ElementTitleEditorView = require './element-title-editor-view'

module.exports =
class PlaceEditorView extends ScrollView
  initialize: (element) ->
    @element = element

  attached: ->
    @titleEditor = new ElementTitleEditorView()
    @titleEditor.initialize(@element)
    @container.append(@titleEditor)

  @content: ->
    @div class: 'block', =>
      @div outlet: 'container'
