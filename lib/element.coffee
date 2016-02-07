crypto = require('crypto')
ElementView = require('./element-view')

module.exports =
class Element

  constructor: ({@title, color, @workflow, @draft} = {}) ->
    @color or= color or 'white'
    @guid = @generateGuid()
    throw new Error("Workflow is required") unless @workflow

  createView: (dc) ->
    new ElementView(@, dc)

  generateGuid: ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = crypto.randomBytes(1)[0]%16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      v.toString(16)
    )

  hasTitle: ->
    @title?.length > 0

  remove: ->
    @workflow.removeElement(@) if @workflow
    @workflow = null
