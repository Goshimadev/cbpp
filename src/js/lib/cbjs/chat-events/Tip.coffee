ChatEvent = require "./ChatEvent"

module.exports = class Tip extends ChatEvent
  toString: ->
    "Tip from #{@tipper.username}: #{@tipAmount} tokens"

Tip.parse = (el) ->
  childs = (child for child in el.childNodes)
  tipper: ChatEvent.parseUserSpan childs.shift()
  tipAmount: parseTipText childs.shift()

parseTipText = (node) ->
  unless matches = node.textContent.match /^ tipped ([0-9])+ token[s]?$/
    throw new Error "Invalid tip text"
  matches[1]
