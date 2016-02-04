Element = require('./element')
ArcView = require('./arc-view')

module.exports =
class Arc extends Element

  constructor: ({from, to, title, color, workflow} = {}) ->
    @fromNode = from
    @toNode = to
    super

  createView: (dc, attributes) ->
    new ArcView(@, dc, attributes)
