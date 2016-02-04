Arc = require './arc'
Place = require './place'
Transition = require './transition'
{Emitter} = require 'atom'

module.exports =
class Workflow

  constructor: (name) ->
    @places = []
    @transitions = []
    @arcs = []
    @name = name
    @emitter = new Emitter()

  onElementsAdded: (callback) ->
    @emitter.on 'elements-added', callback

  onElementsRemoved: (callback) ->
    @emitter.on 'elements-removed', callback

  onNewElement: (callback) ->
    @emitter.on 'new-draft-element', callback

  addNewDraftPlace: ->
    @addNewDraftNode(Place)

  addNewDraftTransition: ->
    @addNewDraftNode(Transition)

  addNewDraftNode: (klass) ->
    node = new klass(x: -10000, y: -10000, draft: true)
    @emitter.emit 'new-draft-element', node

  addNewPlace: (attributes) ->
    @addNewNode(Place, attributes)

  addNewTransition: (attributes) ->
    @addNewNode(Transition, attributes)

  addNewNode: (klass, attributes) ->
    node = new klass(attributes)
    addElement(node)

  addElement: (element) ->
    if element instanceof Place
      @addPlace(element)
    else if element instanceof Transition
      @addTransition(element)
    else if element instanceof Arc
      @addArc(element)

    @emitter.emit 'elements-added', [element]

  addPlace: (place) ->
    @places.push(place)

  addTransition: (transition) ->
    @transitions.push(transition)

  addArc: (arc) ->
    @arcs.push(arc)

  isEmpty: ->
    @places.length == 0
