crypto = require('crypto')

module.exports =
class Node
  x: 0
  y: 0
  color: 'white'
  title: null
  workflow: null
  guid: null

  constructor: ({x, y, color, title, workflow} = {}) ->
    @x = x if x
    @y = y if y
    @title = title if title
    @color = color if color
    @workflow = workflow if workflow
    @guid = @generateGuid()

  generateGuid: ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = crypto.randomBytes(1)[0]%16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      v.toString(16)
    )
