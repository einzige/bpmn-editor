Place = require './place'
Transition = require './transition'

module.exports =
class Workflow
  places: []
  transitions: []
  arcs: []
  name: null

  constructor: (name) ->
    @name = name

  addNode: (node) ->
    if node instanceof Place
      @addPlace(node)
    else if node instanceof Transition
      @addTransition(node)

  addPlace: (place) ->
    @places.push(place)

  addTransition: (transition) ->
    @transitions.push(transition)

  addArc: (arc) ->
    @arcs.push(arc)

  isEmpty: ->
    @places.length == 0
