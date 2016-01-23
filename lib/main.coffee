path = require 'path'
_ = require 'underscore-plus'
TopnetEditor = require './topnet-editor'
{CompositeDisposable} = require 'atom'

module.exports =
  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.addOpener(openURI)
    @subscriptions.add atom.commands.add 'atom-workspace', 'topnet:launch': => @launch()

  deactivate: ->
    @subscriptions.dispose()

  launch: ->
    new TopnetEditor()
    console.log('Topnet was fucking launched!')

# Files with these extensions will be opened as diagrams
businessFlowExtensions = ['.tbf']
openURI = (uriToOpen) ->
  uriExtension = path.extname(uriToOpen).toLowerCase()
  if _.include(businessFlowExtensions, uriExtension)
    new TopnetEditor(uriToOpen)
