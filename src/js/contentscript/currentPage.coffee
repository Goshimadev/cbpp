ChildListChangeNotifier = require('./ChildListChangeNotifier.js')
ChatNotifier = require("./ChatNotifier.js")
ContextMenu = require "./ContextMenu.js"

EventEmitter = require("events").EventEmitter

emitter = new EventEmitter
bodyNotifier = new ChildListChangeNotifier document.body

contextMenu = undefined
bodyNotifier.on "elementAdded", (el) ->
  return unless el.id is "jscontext"
  contextMenu = new ContextMenu el
  emitter.emit "contextMenuAdded", contextMenu
  contextMenu.notifier.on "elementAdded", (el) ->
    return unless el.classList.contains "submenu_profile_info"
    emitter.emit "contextMenuProfileInfoAdded", contextMenu
bodyNotifier.on "elementRemoved", (el) ->
  return unless el.id is "jscontext"
  emitter.emit "contextMenuRemoved"
  return unless contextMenu?
  contextMenu.notifier?.stop()
  contextMenu = undefined

module.exports =
  determineType: ->
    return "chatRoom" if @getChatList()
    return "unknown"

  getUsername: ->
    return "" unless el = @querySelector '#user_information a.username'
    return el.innerText

  querySelector: (selector) ->
    document.body.querySelector selector

  on: (eventName, eventListener) ->
    emitter.on eventName, eventListener

  getChatList: ->
    document.body.querySelector "div.chat-list"

  getChatNotifier: ->
    new ChatNotifier new ChildListChangeNotifier @getChatList()
