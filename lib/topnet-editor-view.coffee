_ = require 'underscore-plus'
path = require 'path'
{$, ScrollView} = require 'atom-space-pen-views'
{Emitter, CompositeDisposable} = require 'atom'
d3 = require 'd3'
Workflow = require './workflow'
WorkflowView = require './workflow-view'

module.exports =
class TopnetEditorView extends ScrollView
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
          @div class: 'toolbox-group', style: 'float: right', =>
            @div class: 'inline-block btn-group', =>
              @button outlet: 'attributeEditorToggleButton', class: 'btn btn-primary icon icon-list-unordered', ""

  attached: ->
    @subscriptions = new CompositeDisposable

    # Add Event handlers here
    @zoomInButton.on 'click', @zoomIn
    @zoomOutButton.on 'click', @zoomOut
    @addPlaceButton.on 'click', @addPlace
    @addTransitionButton.on 'click', @addTransition

    atom.tooltips.add(@attributeEditorToggleButton, {title: 'Attribute Editor'})

    @svg = d3.select("#blueprint").append("svg").attr('class', 'scene')
    @workflow = new Workflow()
    @workflowView = new WorkflowView(@workflow, @svg)

  addPlace: =>
    @workflowView.attachNewPlace()

    unless @hadNewElementHint
      atom.notifications.addInfo("Move cursor to the scene to create place")
      @hadNewElementHint = true

  addTransition: =>
    @workflowView.attachNewTransition()

    unless @hadNewElementHint
      atom.notifications.addInfo("Move cursor to the scene to create transition")
      @hadNewElementHint = true

  detached: ->
    @subscriptions.dispose()

  getPane: ->
    @parents('.pane')[0]

  zoomOut: =>
    @workflowView.zoomOut()

  zoomIn: =>
    @workflowView.zoomIn()
