EventEmitter = require("events").EventEmitter

module.exports = class ChatNotifier
  constructor: (notifier) ->
    @emitter = new EventEmitter
    @notifier = notifier
    @notifier.on "elementAdded", (el) =>
      @emitter.emit determineElType(el), el.innerText
      @emitter.emit "line",
        type: determineElType(el)
        text: el.innerText
    @notifier.on "elementRemoved", (el) =>
      if determineElType(el) is "message"
        @emitter.emit "removedMessage", el.innerText
      else
        console.log "UNEXPECTED ELEMENT REMOVED: #{el.innerText}"

  on: (eventName, eventListener) ->
    @emitter.on eventName, eventListener

determineElType = (el) ->
  return "message" if el.firstChild?.classList.contains "username"
  return "notice" if el.innerText.indexOf("Notice:") is 0
  return "tipAlert" if el.querySelector "span.tipalert"
  return "roomMessage" if el.querySelector "span.roommessagelabel"
  if el.innerText.indexOf("has joined the room") > 0
    return "broadcasterJoinAlert" if el.innerText.indexOf("Broadcaster") is 0
    return "joinAlert"
  if el.innerText.indexOf("has left the room") > 0
    return "broadcasterleaveAlert" if el.innerText.indexOf("Broadcaster") is 0
    return "leaveAlert"
  return "silenceAlert" if el.innerText.indexOf("was silenced by") > 0
  return "kickAlert" if el.innerText.indexOf("was kicked from the room") > 0
  return "recordingNotice" if el.innerText.indexOf("A recording of this private show") is 0
  return "other"
