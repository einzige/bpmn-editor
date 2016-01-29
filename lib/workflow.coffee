Arc = require './arc'
Place = require './place'
Transition = require './transition'

module.exports =
class Workflow

  constructor: (name) ->
    @places = []
    @transitions = []
    @arcs = []
    @name = name

  addElement: (element) ->
    if element instanceof Place
      @addPlace(element)
    else if element instanceof Transition
      @addTransition(element)
    else if element instanceof Arc
      @addArc(element)

  addPlace: (place) ->
    @places.push(place)

  addTransition: (transition) ->
    @transitions.push(transition)

  addArc: (arc) ->
    @arcs.push(arc)

  isEmpty: ->
    @places.length == 0
