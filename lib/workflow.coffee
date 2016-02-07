Arc = require './arc'
Place = require './place'
Transition = require './transition'
{Emitter} = require 'atom'
_ = require 'underscore-plus'

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
    attributes['workflow'] = @
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

  removeElement: (element) ->
    if element instanceof Place
      @removePlace(element)
    else if element instanceof Transition
      @removeTransition(element)
    else if element instanceof Arc
      @removeArc(element)

    @emitter.emit 'elements-removed', [element]

  addPlace: (place) ->
    place.workflow = @
    @places.push(place)

  addTransition: (transition) ->
    transition.workflow = @
    @transitions.push(transition)

  addArc: (arc) ->
    arc.workflow = @
    @arcs.push(arc)

  removePlace: (element) ->
    @places = _.reject(@places, (e) -> e.guid == element.guid)

  removeTransition: (element) ->
    @transitions = _.reject(@transitions, (e) -> e.guid == element.guid)

  removeArc: (element) ->
    @arcs = _.reject(@arcs, (e) -> e.guid == element.guid)

  isEmpty: ->
    @places.length == 0
