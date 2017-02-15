EventEmitter = require('events').EventEmitter

friendlyNames =
  1: "element"
  2: "attribute"
  3: "text"
  8: "comment"

module.exports = class DOMMutationNotifier
  constructor: (el, options={}) ->
    @el = el
    @options = options
    @options.childList ?= true
    @isRunning = false
    unless @options.childList or @options.attributes or @options.characterData
      throw new Error "Neither childList, attributes or characterData chosen."
    @emitter = new EventEmitter
    @observer = new MutationObserver (mutations) =>
      for mutation in mutations
        for addedNode in mutation.addedNodes
          @emitter.emit "#{friendlyNames[addedNode.nodeType]}Added", addedNode
        for removedNode in mutation.removedNodes
          @emitter.emit "#{friendlyNames[removedNode.nodeType]}Removed", removedNode

  on: (eventName, listener) ->
    @emitter.on eventName, listener
    @ensureRunning()

  ensureRunning: ->
    @start() unless @isRunning

  ensureStopped: ->
    @stop() if @isRunning

  start: ->
    throw new Error "DOMMutationNotifier is already running" if @isRunning
    @observer.observe @el, @options
    @isRunning = true

  stop: ->
    throw new Error "DOMMutationNotifier wasn't running" unless @isRunning
    @observer.disconnect()
    @isRunning = false
