Transition = require './transition'
NodeView = require './node-view'

module.exports =
class TransitionView extends NodeView
  h: 30
  w: 30 * 3
  textPadding: 10

  attach: ->
    @view = @dc.append("g")
      .attr('id', @guid)
      .attr('transform', "translate(#{@x()}, #{@y()})")
      .attr("width", @w)
      .attr("height", @h)
      .attr('class', 'transition')

    @rect = @view.append("rect")
      .attr("width", @w)
      .attr("height", @h)
      .attr("fill", @element.color)
      .attr('stroke', 'lightgray')
      .attr('stroke-width', 2)

    @text = @view.append('text')
                 .text(@element.title)
                 .attr('x', @textPadding)
                 .attr('y', 19)

    @w = @text.node().getBBox().width + 2*@textPadding
    @rect.attr('width', @w)
    @view.attr('width', @w)

    @view

  setPosition: (x, y) ->
    @view.attr('transform', "translate(#{x}, #{y})")
    @

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
