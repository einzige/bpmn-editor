{ScrollView} = require 'atom-space-pen-views'

module.exports =
class ElementEditorView extends ScrollView
  initialize: (element) ->
    @element = element

  attached: ->
    # Attach controls here

  @content: ->
    @div class: 'block', =>
      @div outlet: 'container'
