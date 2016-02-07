{ScrollView} = require 'atom-space-pen-views'

module.exports =
class ElementFieldEditorView extends ScrollView
  initialize: (element) ->
    @element = element

  attached: ->
    @_label.text(@label())
    @editorView = @buildEditorView()
    @container.append(@editorView)
    @pullData()

  pullData: =>
    ;

  bindedData: ->
    {}

  changed: =>
    @element.change(@bindedData())

  @content: ->
    @div class: 'block', =>
      @div outlet: 'container', =>
        @label outlet: '_label'
