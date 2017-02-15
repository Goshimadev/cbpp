module.exports = class ChatLine
  constructor: (el) ->
    @type = getLineType el
    @el = el

getLineType = (el) ->
  return "message" if el.firstChild?.classList.contains "username"
  return "roomMessage" if el.querySelector "span.roommessagelabel"
  return "notice" if el.textContent.startsWith "Notice:"
  return "tipAlert" if el.querySelector "span.tipalert"
  if el.textContent.includes "has joined the room"
    return "broadcasterJoinAlert" if el.textContent.startsWith "Broadcaster"
    return "joinAlert"
  if el.textContent.includes "has left the room"
    return "broadcasterleaveAlert" if el.textContent.startsWith "Broadcaster"
    return "leaveAlert"
  return "silenceAlert" if el.textContent.includes "was silenced by"
  return "kickAlert" if el.textContent.includes "was kicked out of the room"
  return "privateShowStart" if el.textContent.startsWith "Private show has started"
  return "privateShowEnd" if el.textContent.startsWith "Private show has ended"
  return "recordingNotice" if el.textContent.startsWith "A recording of this private show"
  return "addModerator" if el.textContent.includes "has granted moderator privileges to"
  if el.firstChild?.tagName is "P"
    return "connectionEstablished" if el.textContent.trim() is "connection established"
    return "chatDisconnected" if el.textContent.trim() is "chat disconnected"
    return "reconnectAttempt" if el.textContent.trim() is "trying to reconnect"
    return "rulesBlurp" if el.textContent.startsWith "Rules:"
    return "helpBlurb" if el.textContent.startsWith "To go to next room"
    return "appInfo" if el.textContent.includes "is running these apps"
    return "other-paragraph"
  return "removeModerator" if false
  return "other"
