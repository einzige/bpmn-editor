Element = require('./element')
ArcView = require('./arc-view')

module.exports =
class Arc extends Element
  fromNode: null
  toNode: null

  constructor: ({from, to, title, color, workflow} = {}) ->
    @fromNode = from if from
    @toNode = to if to
    super

  createView: (dc) ->
    new ArcView(@, dc)
