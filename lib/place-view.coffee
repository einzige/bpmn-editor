Place = require './place'
NodeView = require './node-view'

module.exports =
class PlaceView extends NodeView
  r: 15

  draw: ->
    @view = @dc.append("circle")
      .attr('id', @guid)
      .attr("cx", @node.x)
      .attr("cy", @node.y)
      .attr("r", @r)
      .attr("fill", @node.color)
      .attr('stroke', 'lightgray')
      .attr('stroke-width', 2)

  move: (x, y) ->
    @node.x = x
    @node.y = y
    @view.attr('cx', x)
    @view.attr('cy', y)
    # @view.attr("transform", "translate(" + x + "," + y + ")");

  shift: (dx, dy) ->
    x = @node.x + dx
    y = @node.y + dy
    @move(x, y)
