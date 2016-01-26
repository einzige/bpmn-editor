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
