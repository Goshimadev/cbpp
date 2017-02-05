rpcGateway = require "../rpcGateway.js"
rpcGateway.listen()

getDB = require '../getDB.js'
getDB()

chrome.runtime.onMessage.addListener (msg, sender, sendResponse) ->
  return if msg.type is "RPC"
  sendResponse
    type: "Message error"
    data: "Unknown message type '#{message.type}'"

window.commands = require "./commands.js"
