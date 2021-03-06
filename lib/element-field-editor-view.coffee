{ScrollView} = require 'atom-space-pen-views'

module.exports =
class ElementFieldEditorView extends ScrollView
  initialize: (element) ->
    @element = element
    @element.onChange(@elementChanged) if @element

  attached: =>
    @_label.text(@label())
    @editorView = @buildEditorView()
    @container.append(@editorView)
    @_pullData()

  pullData: =>
    ;

  bindedData: ->
    {}

  changed: =>
    @element.change(@bindedData(), @) unless @pulling

  elementChanged: (source) =>
    @_pullData() unless source == @

  _pullData: ->
    @pulling = true
    @pullData()
    @pulling = false

  @content: ->
    @div class: 'block', =>
      @div outlet: 'container', =>
        @label outlet: '_label'
