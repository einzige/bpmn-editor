path = require 'path'
_ = require 'underscore-plus'
{CompositeDisposable} = require 'atom'
TopnetEditor = require './topnet-editor'

module.exports =
  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.workspace.addOpener(openURI))

  deactivate: ->
    @subscriptions.dispose()

# Files with these extensions will be opened as diagrams
businessFlowExtensions = ['.tbf']
openURI = (uriToOpen) ->
  uriExtension = path.extname(uriToOpen).toLowerCase()
  if _.include(businessFlowExtensions, uriExtension)
    new TopnetEditor(uriToOpen)
