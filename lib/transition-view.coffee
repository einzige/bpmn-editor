Transition = require './transition'
NodeView = require './node-view'

module.exports =
class TransitionView extends NodeView
  h: 30
  w: 30 * 3

  attach: ->
    @view = @dc.append("rect")
      .attr('id', @guid)
      .attr("x", @element.x)
      .attr("y", @element.y)
      .attr("width", @w)
      .attr("height", @h)
      .attr("fill", @element.color)
      .attr('stroke', 'lightgray')
      .attr('stroke-width', 2)
