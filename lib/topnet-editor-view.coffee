_ = require 'underscore-plus'
path = require 'path'
{$, ScrollView} = require 'atom-space-pen-views'
{Emitter, CompositeDisposable} = require 'atom'
d3 = require 'd3'
Workflow = require './workflow'
WorkflowView = require './workflow-view'
AttributeEditor = require './attribute-editor'
AttributeEditorView = require './attribute-editor-view'
SelectionHandler = require './selection-handler'

atom.views.addViewProvider AttributeEditor, (attributeEditor) ->
  new AttributeEditorView(attributeEditor)

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
        @tag 'svg', class: 'scene'

  attached: ->
    @subscriptions = new CompositeDisposable

    @selectionHandler = new SelectionHandler()
    @attributeEditor = new AttributeEditor(selectionHandler: @selectionHandler, visible: true)
    atom.views.getView(@attributeEditor).attach()
    atom.tooltips.add(@attributeEditorToggleButton, {title: 'Attribute Editor'})

    @workflow = new Workflow()
    @workflowView = new WorkflowView(@workflow, d3.select("#blueprint .scene"))

    @workflowView.onNodeClicked (nodeView) =>
      @selectionHandler.setSelection(nodeView)

    @workflowView.onEmptySpaceClicked =>
      @selectionHandler.deselectAll()

    @workflowView.onNodeAttached (nodeView) =>
      @selectionHandler.setSelection(nodeView)

    # Add Event handlers here
    @zoomInButton.on 'click', @zoomIn
    @zoomOutButton.on 'click', @zoomOut
    @addPlaceButton.on 'click', @addPlace
    @addTransitionButton.on 'click', @addTransition
    @attributeEditorToggleButton.on 'click', @toggleAttributeEditor
    atom.workspace.observeActivePaneItem(@onPaneChange)

  addPlace: =>
    @workflow.addNewDraftPlace()

    unless @hadNewElementHint
      atom.notifications.addInfo("Move cursor to the scene to create place")
      @hadNewElementHint = true

  addTransition: =>
    @workflow.addNewDraftTransition()

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

  toggleAttributeEditor: =>
    @attributeEditor.toggle()

  onPaneChange: (paneItem) =>
    pane = atom.views.getView(paneItem)
    attributeEditorView = atom.views.getView(@attributeEditor)

    if pane == @element
      attributeEditorView.update()
    else
      attributeEditorView.hide()
