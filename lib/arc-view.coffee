d3 = require('d3')
Arc = require('./arc')
ElementView = require('./element-view')

module.exports =
class ArcView extends ElementView
  interpolation: 'basis'
  curvature: 30

  constructor: (@element, @dc, {draft, @fromView, @toView} = {draft: false, fromView: null, toView: null}) ->
    super

  redraw: ->
    @attach() unless @view
    @view.attr('d', @d())

  attach: ->
    @fromView.attachArc(@)
    @toView.attachArc(@)

    @view = @dc.append('path')
               .attr('d', @d())
               .attr('stroke', 'lightgray')
               .attr('stroke-width', 2)
               .attr('fill', 'none')

    @toDraft() if @draft

  detach: ->
    @fromView.detachArc(@) if @fromView
    @toView.detachArc(@) if @toView
    super

  fromX: ->
    @element.fromNode.x

  fromY: ->
    @element.fromNode.y

  toX: ->
    @element.toNode.x

  toY: ->
    @element.toNode.y

  d: ->
    @_lineFunction or= d3.svg.line()
                             .x((d) -> d.x)
                             .y((d) -> d.y)
                             .interpolate(@interpolation)
    @_lineFunction(@linePathData())

  linePathData: ->
    a = Math.atan2(@toY() - @fromY(), @toX() - @fromX()) * 180 / Math.PI;
    console.log(a)

    startX = @fromX()
    startY = @fromY()
    endX = @toX()
    endY = @toY()

    [startX, startY] = if a > 0
      if a <= 22.5
        @fromView.right()
      else if a <= 22.5 + 45
        @fromView.bottomRight()
      else if a <= 22.5 + 45 * 2
        @fromView.bottom()
      else if a <= 22.5 + 45 * 3
        @fromView.bottomLeft()
      else
        @fromView.left()
    else
      a = -1*a
      if a <= 22.5
        @fromView.right()
      else if a <= 22.5 + 45
        @fromView.topRight()
      else if a <= 22.5 + 45 * 2
        @fromView.top()
      else if a <= 22.5 + 45 * 3
        @fromView.topLeft()
      else
        @fromView.left()

    [
      {x: startX, y: startY}
      {x: endX, y: endY}
    ]
