Workflow = require './workflow'
Place = require './place'
PlaceView = require './place-view'

module.exports =
class WorkflowView
  workflow: null
  dc: null
  elements: {}

  constructor: (@workflow, @dc) ->
    if @workflow.isEmpty()
      start = new Place(start: true, x: 20, y: 100)
      finish = new Place(finish: true, x: 200, y: 100)
      @workflow.addPlace(start)
      @workflow.addPlace(finish)

  draw: ->
    @drawPlace(place) for place in @workflow.places

  drawPlace: (place) ->
    view = new PlaceView(place, @dc)
    @elements[place.guid] = view
    console.log(@elements)
    view.draw()

  addNewPlace: ->
    place = new Place(x: 50, y: 50)
    @autoreposition(place) while @overlaps(place)
    @workflow.addPlace(place)
    @drawPlace(place)

  autoreposition: (node) ->
    node.x += 50
    node.y += 50

  overlaps: (node) ->
    for place in @workflow.places
      return true if node.x == place.x && node.y == place.y
    false
