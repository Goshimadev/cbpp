EventEmitter = require('events').EventEmitter

friendlyNames =
  1: "element"
  2: "attribute"
  3: "text"
  8: "comment"

module.exports = class ChildListChangeNotifier extends EventEmitter
  constructor: (el, subtree = false) ->
    @subtree = subtree
    @el = el
    @emitter = new EventEmitter
    @observer = new MutationObserver (mutations) =>
      for mutation in mutations
        @emitter.emit "mutation", mutation
        for addedNode in mutation.addedNodes
          @emitter.emit "nodeAdded", addedNode
          @emitter.emit "#{friendlyNames[addedNode.nodeType]}Added", addedNode
        for removedNode in mutation.removedNodes
          @emitter.emit "nodeRemoved", removedNode
          @emitter.emit "#{friendlyNames[removedNode.nodeType]}Removed", removedNode
    @start()

  on: (eventName, listener) ->
    @emitter.on eventName, listener

  start: ->
    @observer.observe @el,
      childList: true
      subtree: @subtree

  stop: ->
    @observer.disconnect()
