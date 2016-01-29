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

  width: ->
    @w

  height: ->
    @h

  top: ->
    [@x() + @wd2(), @y()]

  topLeft: ->
    [@x(), @y()]

  topRight: ->
    [@x() + @width(), @y()]

  left: ->
    [@x(), @y() + @hd2()]

  right: ->
    [@x() + @width(), @y() + @hd2()]

  bottomLeft: ->
    [@x(), @y() + @height()]

  bottom: ->
    [@x() + @wd2(), @y() + @height()]

  bottomRight: ->
    [@x() + @width(), @y() + @height()]

  wd2: ->
    @width() / 2

  hd2: ->
    @height() / 2
