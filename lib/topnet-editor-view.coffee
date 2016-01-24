_ = require 'underscore-plus'
path = require 'path'
{$, ScrollView} = require 'atom-space-pen-views'
{Emitter, CompositeDisposable} = require 'atom'
d3 = require 'd3'

module.exports =
class TopnetEditorView extends ScrollView
  minZoomLevel: 0.3
  maxZoomLevel: 8
  zoomFactor: 0.08

  @content: ->
    @div class: 'topnet', tabindex: -1, =>
      @div class: 'blueprint', id: 'blueprint', tabindex: -1, =>
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

  attached: ->
    @subscriptions = new CompositeDisposable

    # Add Event handlers here
    @zoomInButton.on 'click', @zoomIn
    @zoomOutButton.on 'click', @zoomOut

    @zoom = d3.behavior.zoom()
      .scaleExtent([@minZoomLevel, @maxZoomLevel])
      .on("zoom", @zoomed)

    @svg = d3.select("#blueprint")
      .append("svg")
      .attr('class', 'scene')
      .call(@zoom)

    # Drawing context
    @dc = @svg.append("g")

    @dc.append("circle")
      .attr("cx", 250)
      .attr("cy", 250)
      .attr("r", 15)
      .attr("fill", "white")
      .attr('stroke', 'lightgray')
      .attr('stroke-width', 2)

  detached: ->
    @subscriptions.dispose()

  getPane: ->
    @parents('.pane')[0]

  zoomed: =>
    @dc.attr("transform", "translate(" + @zoom.translate() + ")scale(" + @zoom.scale() + ")")

  zoomOut: =>
    @zoom.scale(@zoom.scale() * (1 - @zoomFactor))
    @zoomed()

  zoomIn: =>
    @zoom.scale(@zoom.scale() * (1 + @zoomFactor))
    @zoomed()
