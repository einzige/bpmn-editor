d3 = require('d3')
Arc = require('./arc')
ElementView = require('./element-view')

module.exports =
class ArcView extends ElementView
  interpolation: 'basis'
  curvature: 30

  constructor: (@element, @dc, {draft, @fromView, @toView} = {draft: false, fromView: null, toView: null}) ->
    super
    @setupArrows()

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
               .attr('stroke-linecap', 'round')
               .attr('fill', 'none')
               .attr("marker-end", "url(#arrow)")

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

  # TODO: refactor
  linePathData: ->
    a = Math.atan2(@toY() - @fromY(), @toX() - @fromX()) * 180 / Math.PI;

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
      b = -1*a
      if b <= 22.5
        @fromView.right()
      else if b <= 22.5 + 45
        @fromView.topRight()
      else if b <= 22.5 + 45 * 2
        @fromView.top()
      else if b <= 22.5 + 45 * 3
        @fromView.topLeft()
      else
        @fromView.left()

    [endX, endY] = if a < 0
      b = -1*a
      if b <= 22.5
        @toView.left()
      else if b <= 22.5 + 45
        @toView.bottomLeft()
      else if b <= 22.5 + 45 * 2
        @toView.bottom()
      else if b <= 22.5 + 45 * 3
        @toView.bottomRight()
      else
        @toView.right()
    else
      if a <= 22.5
        @toView.left()
      else if a <= 22.5 + 45
        @toView.topLeft()
      else if a <= 22.5 + 45 * 2
        @toView.top()
      else if a <= 22.5 + 45 * 3
        @toView.topRight()
      else
        @toView.right()

    [
      {x: startX, y: startY}
      {x: endX, y: endY}
    ]

  setupArrows: ->
    return unless @dc.select('defs').empty()

    defs = @dc.append("defs")
    defs.append("marker")
        .attr(
          id: "arrow",
          viewBox: "-5 -5 10 10",
          refX: 5,
          refY: 0,
          markerWidth: 4,
          markerHeight: 4,
          orient: "auto")
        .append("path")
        .attr("d", "M 0,0 m -5,-5 L 5,0 L -5,5 Z")
        .attr("class", "arrowHead")
        .attr('fill', 'white')
