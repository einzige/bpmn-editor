Place = require './place'
NodeView = require './node-view'

module.exports =
class PlaceView extends NodeView
  r: 15
  sqrt2: 1.41421356237

  setPosition: (x, y) ->
    @view.attr('cx', x)
    @view.attr('cy', y)

  attach: ->
    @view = @dc.append("circle")
      .attr('id', @guid)
      .attr("cx", @element.x)
      .attr("cy", @element.y)
      .attr("r", @r)
      .attr("fill", @element.color)
      .attr('stroke', 'lightgray')
      .attr('stroke-width', 2)

  top: ->
    [@x(), @y() - @r]

  topLeft: ->
    leg = @r / @sqrt2
    [@x() - leg, @y() - leg]

  topRight: ->
    leg = @r / @sqrt2
    [@x() + leg, @y() - leg]

  left: ->
    [@x() - @r, @y()]

  right: ->
    [@x() + @r, @y()]

  bottomLeft: ->
    leg = @r / @sqrt2
    [@x() - leg, @y() + leg]

  bottom: ->
    leg = @r / @sqrt2
    [@x(), @y() + @r]

  bottomRight: ->
    leg = @r / @sqrt2
    [@x() + leg, @y() + leg]
