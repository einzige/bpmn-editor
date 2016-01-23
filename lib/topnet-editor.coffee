path = require 'path'
fs = require 'fs-plus'
{File, CompositeDisposable} = require 'atom'

# Editor model for a diagram file
module.exports =
class TopnetEditor
  atom.deserializers.add(this)

  @deserialize: ({filePath}) ->
    if filePath
      if fs.isFileSync(filePath)
        new TopnetEditor(filePath)
      else
        console.warn "Could not deserialize topnet editor for path '#{filePath}' because that file no longer exists"
    else
      new TopnetEditor()

  constructor: (filePath) ->
    if filePath
      @file = new File(filePath)
    @subscriptions = new CompositeDisposable()

  serialize: ->
    {filePath: @getPath(), deserializer: @constructor.name}

  getViewClass: ->
    require './topnet-editor-view'

  # Register a callback for when the diagram file changes
  onDidChange: (callback) ->
    if @file
      changeSubscription = @file.onDidChange(callback)
      @subscriptions.add(changeSubscription)
      changeSubscription

  # Register a callback for when the diagram's title changes
  onDidChangeTitle: (callback) ->
    if @file
      renameSubscription = @file.onDidRename(callback)
      @subscriptions.add(renameSubscription)
      renameSubscription

  destroy: ->
    @subscriptions.dispose()

  # Retrieves the filename of the open file.
  #
  # This is `'untitled'` if the file is new and not saved to the disk.
  #
  # Returns a {String}.
  getTitle: ->
    if filePath = @getPath()
      path.basename(filePath)
    else
      'untitled'

  # Retrieves the URI of the diagram.
  #
  # Returns a {String}.
  getURI: ->
    if @file
      encodeURI(@getPath()).replace(/#/g, '%23').replace(/\?/g, '%3F')

  # Retrieves the absolute path to the diagram.
  #
  # Returns a {String} path.
  getPath: ->
    if @file
      @file.getPath()

  # Compares two {TopnetEditor}s to determine equality.
  #
  # Equality is based on the condition that the two URIs are the same.
  #
  # Returns a {Boolean}.
  isEqual: (other) ->
    other instanceof TopnetEditor and @getURI() is other.getURI()
