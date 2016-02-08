Transition = require './transition'
NodeView = require './node-view'

module.exports =
class TransitionView extends NodeView
  h: 30
  w: 30 * 3
  textPadding: 10

  primitive: -> @rect

  attach: ->
    @view = @dc.insert("g", ':first-child').attr('class', 'transition')
    @rect = @view.append("rect")
    @text = @view.append('text')
                 .attr('x', @textPadding)
                 .attr('y', 19)
    super

  redraw: ->
    super
    @text.text(@element.title)

    @w = @text.node().getBBox().width + 2*@textPadding
    @rect.attr('width', @w).attr('height', @h)
    @view.attr('width', @w).attr("height", @h)

  setPosition: (x, y) ->
    @view.attr('transform', "translate(#{x}, #{y})")
    @

  width: ->
    @w

  height: ->
    @h

  centerX: ->
    @x() + @wd2()

  centerY: ->
    @y() + @hd2()

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
