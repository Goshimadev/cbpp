ChatEvent = require "./ChatEvent"

module.exports = class Message extends ChatEvent
  toString: ->
    if @valid
      "Message from #{@sender.username}: #{@contents.text}"
    else
      "Invalid message: #{@el.textContent}. #{@errorMessage}"

Message.parse = (el) ->
  childs = (child for child in el.childNodes)
  sender: ChatEvent.parseUserSpan childs.shift()
  contents: ChatEvent.parseMessageContents childs
