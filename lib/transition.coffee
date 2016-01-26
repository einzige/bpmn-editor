Node = require './node'

module.exports =
class Transition extends Node
  action: null
  color: '#efefef'

  constructor: ({x, y, color, title, action, workflow} = {}) ->
    if action
      @action = action
      @color = 'white'
    super
