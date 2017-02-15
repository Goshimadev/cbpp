ChatEventNotifier = require "../ChatEventNotifier"
ContextMenuNotifier = require "../ContextMenuNotifier"

GenericPage = require './GenericPage'

module.exports = class ChatRoomPage extends GenericPage
  constructor: (document) ->
    @document = document
    @body = document.body
    @type = "chatRoom"
    @contextMenuNotifier = undefined
    @chatEventNotifer = undefined

  getContextMenuNotifier: ->
    @contextMenuNotifer ?= new ContextMenuNotifier @body

  getChatList: ->
    @body.querySelector "div.chat-list"

  getChatEventNotifier: ->
    @chatEventNotfier ?= new ChatEventNotifier @getChatList()
