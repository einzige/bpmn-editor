d3 = require('d3')
Arc = require('./arc')
ElementView = require('./element-view')

module.exports =
class ArcView extends ElementView
  constructor: (@element, @dc, {draft, fromView, toView} = {draft: false, fromView: null, toView: null}) ->
    super
    if fromView
      @fromView = fromView
      @fromView.attachArc(@)

    if toView
      @toView = toView
      @toView.attachArc(@)

  redraw: ->
    @attach() unless @view
    @view.attr('d', @d())

  attach: ->
    @view = @dc.append('path')
               .attr('d', @d())
               .attr('stroke', 'lightgray')
               .attr('stroke-width', 2)
               .attr('fill', 'none')

  detach: ->
    @fromView.detachArc(@) if @fromView
    @toView.detachArc(@) if @toView
    super

  fromX: ->
    @element.fromNode.x

  fromY: ->
    @element.fromNode.x

  toX: ->
    @element.toNode.x

  toY: ->
    @element.toNode.y

  d: ->
    @_lineFunction or= d3.svg.line()
                             .x((d) -> d.x)
                             .y((d) -> d.y)
                             .interpolate("linear")
    @_lineFunction(@linePathData())

  linePathData: ->
    [
      {x: @fromX(), y: @fromY()}, {x: @toX(), y: @toY()}
    ]
