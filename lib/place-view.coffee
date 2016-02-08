Place = require './place'
NodeView = require './node-view'

module.exports =
class PlaceView extends NodeView
  r: 15
  sqrt2: 1.41421356237
  textPadding: 12

  textColor: -> if @selected then 'orange' else 'white'

  selectionTarget: -> @circle
  primitive: -> @circle

  attach: ->
    @view = @dc.insert("g", ':first-child').attr('class', 'place')
    @circle = @view.insert("circle", ':first-child').attr("r", @r)
    @text = @view.append('text').attr('x', @textPadding).attr('y', -@textPadding)

    super

  redraw: ->
    super
    @text.text(@element.title).attr('fill', @textColor())

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
