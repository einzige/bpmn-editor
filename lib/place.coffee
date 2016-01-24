Node = require './node'

module.exports =
class Place extends Node
  start: false
  finish: false

  constructor: ({x, y, color, title, start, finish, workflow} = {}) ->
    @start = start or false
    @finish = finish or false

    if color
      @color = color
    else if @start
      @color = "#5ad"
    else if @finish
      @color = "#5c0"

    super
