Place = require './place'
NodeView = require './node-view'

module.exports =
class PlaceView extends NodeView
  r: 15
  sqrt2: 1.41421356237
  textPadding: 12

  setPosition: (x, y) ->
    @view.attr('transform', "translate(#{x}, #{y})")

  selectionTarget: -> @circle
  primitive: -> @circle

  attach: ->
    @view = @dc.insert("g", ':first-child').attr('class', 'place')
    @circle = @view.insert("circle", ':first-child').attr("r", @r)

    if @element.hasTitle()
      @text = @view.append('text').attr('x', @textPadding).attr('y', -@textPadding)

    super

  redraw: ->
    super
    @view.attr('transform', "translate(#{@x()}, #{@y()})")
    @text.text(@element.title)

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
