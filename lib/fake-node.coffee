Node = require './node'
FakeNodeView = require './fake-node-view'

module.exports =
class FakeNode extends Node

  createView: (dc, {draft} = {draft: true}) ->
    new FakeNodeView(@, dc, draft: draft)
