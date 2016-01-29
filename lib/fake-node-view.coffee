FakeNode = require './fake-node'
NodeView = require './node-view'

module.exports =
class FakeNodeView extends NodeView

  setPosition: (x, y) -> ;

  attach: -> ;

  top: ->
    [@x(), @y()]

  topLeft: ->
    @top()

  topRight: ->
    @top()

  left: ->
    @top()

  right: ->
    @top()

  bottomLeft: ->
    @top()

  bottom: ->
    @top()

  bottomRight: ->
    @top()
