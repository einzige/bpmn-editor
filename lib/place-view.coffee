Place = require './place'
NodeView = require './node-view'

module.exports =
class PlaceView extends NodeView
  r: 15
  sqrt2: 1.41421356237
  textPadding: 12

  setPosition: (x, y) ->
    @view.attr('transform', "translate(#{x}, #{y})")

  attach: ->
    @view = @dc.insert("g", ':first-child')
               .attr('transform', "translate(#{@x()}, #{@y()})")
               .attr('class', 'place')

    if @element.hasTitle()
      @text = @view.append('text')
                   .text(@element.title)
                   .attr('x', @textPadding)
                   .attr('y', -@textPadding)

    @circle = @view.insert("circle", ':first-child')
                   .attr('id', @guid)
                   .attr("r", @r)
                   .attr("fill", @element.color)
                   .attr('stroke', 'lightgray')
                   .attr('stroke-width', 2)

    @toDraft() if @draft

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
