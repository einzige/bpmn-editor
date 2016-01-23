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
        @span "fuck this shit"

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
    #d3.select("#blueprint").append("svg").attr("width", 50).attr("height", 50).append("circle").attr("cx", 25).attr("cy", 25).attr("r", 25).style("fill", "purple")
    width = 900
    height = 500

    @svg = d3.select("#blueprint").append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .call(d3.behavior.zoom().scaleExtent([1, 8]).on("zoom", @zoom))
      .append("g");
    
    @svg.append("rect")
      .attr("class", "overlay")
      .attr("width", width)
      .attr("height", height);

    @svg.append("circle").attr("cx", 25).attr("cy", 25).attr("r", 25).style("fill", "purple")

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
    @svg.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");

  # Zooms the image out by 10%.
  zoomOut: ->
    #@adjustSize(0.9)

  # Zooms the image in by 10%.
  zoomIn: ->
    #@adjustSize(1.1)
