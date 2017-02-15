pageTypes =
  "chatRoom": require "./elements/ChatRoomPage"
  "generic": require "./elements/GenericPage"

querySelector = (selector) -> document.querySelector selector

module.exports =
  getPage: ->
    new pageTypes[@getPageType()] document

  getPageType: ->
    return "chatRoom" if querySelector "div.chat-list"
    return "generic"
