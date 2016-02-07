{$, ScrollView} = require 'atom-space-pen-views'
{TextEditor} = require 'atom'

module.exports =
class PlaceEditorView extends ScrollView
  initialize: (element) ->
    super
    @element = element
    @title = new TextEditor(mini: true, placeholderText: 'Element title')
    @titleView = atom.views.getView(@title)
    @titleEditorContainer.append(@titleView)
    @title.onDidChange(@changeTitle)
    @pullData()

  changeTitle: =>
    @element.setTitle(@title.getText())

  pullData: =>
    @title.setText(@element.title())

  @content: ->
    @div class: 'block', =>
      @label "Title"
      @div outlet: 'titleEditorContainer'
