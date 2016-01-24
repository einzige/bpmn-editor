Place = require './place'

module.exports =
class Workflow
  places: []
  transitions: []
  arcs: []
  name: null

  constructor: (name) ->
    @name = name

  addPlace: (place) ->
    @places.push(place)

  addTransition: (transition) ->
    @transitions.push(transition)

  addArc: (arc) ->
    @arcs.push(arc)

  isEmpty: ->
    @places.length == 0
