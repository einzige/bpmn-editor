_ = require 'underscore-plus'
path = require 'path'
{$, ScrollView} = require 'atom-space-pen-views'
{Emitter, CompositeDisposable} = require 'atom'
d3 = require 'd3'

module.exports =
class TopnetEditorView extends ScrollView
  @content: ->
    @div class: 'topnet', tabindex: -1, =>
      @div class: 'blueprint', id: 'blueprint', =>
        @div class: 'toolbox', =>
          @div class: 'block', =>
            @button class: 'btn btn-primary inline-block-tight', =>
              "Place"
            @button class: 'btn btn-primary inline-block-tight', =>
              "Transition"
        @span "fuck this shit"

  initialize: (@editor) ->
    super
    @emitter = new Emitter

  attached: ->
    @disposables = new CompositeDisposable
    @loaded = false
    d3.select("#blueprint").append("svg").attr("width", 50).attr("height", 50).append("circle").attr("cx", 25).attr("cy", 25).attr("r", 25).style("fill", "purple")

    # @disposables.add @editor.onDidChange => @updateImageURI()
    # @disposables.add atom.commands.add @element,
    #   'image-view:reload': => @updateImageURI()
    #   'image-view:zoom-in': => @zoomIn()
    #   'image-view:zoom-out': => @zoomOut()
    #   'image-view:reset-zoom': => @resetZoom()

  onDidLoad: (callback) ->
    @emitter.on 'did-load', callback

  detached: ->
    @disposables.dispose()

  # Retrieves this view's pane.
  #
  # Returns a {Pane}.
  getPane: ->
    @parents('.pane')[0]

  # Zooms the image out by 10%.
  zoomOut: ->
    @adjustSize(0.9)

  # Zooms the image in by 10%.
  zoomIn: ->
    @adjustSize(1.1)
