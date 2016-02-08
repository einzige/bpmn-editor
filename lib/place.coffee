Node = require './node'
PlaceView = require './place-view'

module.exports =
class Place extends Node

  constructor: ({x, y, color, title, @start, @finish, workflow} = {start: false, finish: false}) ->
    if color
      @color = color
    else if @start
      @color = "#5ad"
    else if @finish
      @color = "#5c0"

    super

    @title = ""

  createView: (dc, attributes) ->
    new PlaceView(@, dc, attributes)
