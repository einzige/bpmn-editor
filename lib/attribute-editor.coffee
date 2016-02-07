{Emitter} = require 'atom'
AttributeEditorView = require './attribute-editor-view'

module.exports =
class AttributeEditor

  constructor: ({@selectionHandler, visible} = {visible: true}) ->
    @emitter = new Emitter
    @isVisible = visible

  visible: -> @isVisible
  hidden: -> !@isVisible

  onDidHide: (callback) ->
    @emitter.on 'did-hide', callback

  onDidShow: (callback) ->
    @emitter.on 'did-show', callback

  onDidChangeVisibility: (callback) ->
    @emitter.on 'did-change-visibility', callback

  toggle: ->
    if @visible() then @hide() else @show()

  hide: ->
    @isVisible = false
    @emitter.emit 'did-hide'
    @emitter.emit 'did-change-visibility', @isVisible

  show: ->
    @isVisible = true
    @emitter.emit 'did-show'
    @emitter.emit 'did-change-visibility', @isVisible
