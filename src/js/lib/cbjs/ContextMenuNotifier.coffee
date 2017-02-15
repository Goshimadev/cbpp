EventEmitter = require("events").EventEmitter

MutationNotifier = require '../dom-mutation-notifier'

ContextMenu = require "./elements/ContextMenu"

module.exports = class ContextMenuNotifier
  constructor: (body) ->
    console.log "Creating ContextMenuNotifier"
    emitter = new EventEmitter
    innerNotifier = undefined
    outerNotifier = new MutationNotifier body
    outerNotifier.on "elementAdded", (el) =>
      return unless el.id is "jscontext"
      innerNotifier = new MutationNotifier el, {childList: true, subtree: true}
      innerNotifier.start()
      innerNotifier.on "elementAdded", (profileEl) =>
        return unless profileEl.classList.contains "submenu_profile_info"
        emitter.emit "menuReady", new ContextMenu el
    outerNotifier.on "elementRemoved", (el) =>
      return unless el.id is "jscontext"
      innerNotifier.stop()
    @on = (eventName, eventListener) ->
      emitter.on eventName, eventListener
