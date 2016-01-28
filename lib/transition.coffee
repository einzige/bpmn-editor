Node = require './node'
TransitionView = require './transition-view'

module.exports =
class Transition extends Node

  constructor: ({x, y, color, title, action, workflow} = {}) ->
    @color = color or '#efefef'

    if action
      @action = action
      @color = 'white'
    super

  createView: (dc) ->
    new TransitionView(@, dc)
