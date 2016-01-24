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
          @div class: 'toolbox-group', =>
            @label "Elements"
            @div class: 'inline-block btn-group', =>
              @button outlet: 'addPlaceButton', class: 'btn btn-primary icon icon-globe', "Place"
              @button outlet: 'addTransitionButton', class: 'btn btn-primary icon icon-browser', "Transition"
          @div class: 'toolbox-group', =>
            @label "Zoom"
            @div class: 'inline-block btn-group', =>
              @button outlet: 'zoomInButton', class: 'btn btn-primary icon icon-file-directory-create', ""
              @button outlet: 'zoomOutButton', class: 'btn btn-primary icon icon-dash', ""

  initialize: (@editor) ->
    super
    @emitter = new Emitter

  attached: ->
    @disposables = new CompositeDisposable
    @loaded = false

    # Add Event handlers here
    @zoomInButton.on 'click', (e) => @zoomIn()
    @zoomOutButton.on 'click', (e) => @zoomOut()

    # Draw Petri here
    width = @getPane().clientWidth
    height = @getPane().clientHeight - 42

    debugger

    zoomListener = d3.behavior.zoom().scaleExtent([1, 8]).on("zoom", @zoom)

    @svg = d3.select("#blueprint")
      .append("svg")
      .attr("width", width)
      .attr("height", height)
      .attr('class', 'scene')
      .call(zoomListener)

    @dc = @svg.append("g")

    @dc.append("circle")
      .attr("cx", 250)
      .attr("cy", 250)
      .attr("r", 15)
      .attr("fill", "white")
      .attr('stroke', 'lightgray')
      .attr('stroke-width', 2)

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

  zoom: =>
    @dc.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");

  # Zooms the image out by 10%.
  zoomOut: ->
    #@adjustSize(0.9)

  # Zooms the image in by 10%.
  zoomIn: ->
    #@adjustSize(1.1)
