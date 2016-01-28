crypto = require('crypto')
ElementView = require('./element-view')

module.exports =
class Element
  color: 'white'
  title: null
  workflow: null
  guid: null
  draft: false

  constructor: ({title, color, workflow} = {}) ->
    @title = title if title
    @color = color if color
    @workflow = workflow if workflow
    @guid = @generateGuid()

  createView: (dc) ->
    new ElementView(@, dc)

  generateGuid: ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = crypto.randomBytes(1)[0]%16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      v.toString(16)
    )
