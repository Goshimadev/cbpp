chrome = require "then-chrome"
delay = require "call-delayed"
Bluebird = require "bluebird"

makeLogged = require "../lib/make-logged.js"

page = require "./currentPage.js"
sendRPC = require("../rpcGateway.js").sendRPC
sendRPC = makeLogged sendRPC

module.exports = main = Bluebird.coroutine ->
  {options,devOptions} = yield chrome.storage.local.get ["options","devOptions"]
  options ?= {}
  devOptions ?= {}
  for optionName in ["hideVideo","hideThumbnails","reduceNoise"]
    document.body.classList.add optionName if devOptions[optionName]

  pageType = page.determineType()
  console.log "Logged in on Chaturbate as #{page.getUsername()}"

  return unless pageType is "chatRoom"
  page.on "contextMenuAdded", (menu) ->
    menu.replaceCornerImg()
  page.on "contextMenuProfileInfoAdded", Bluebird.coroutine (menu) ->
    menu.replaceCornerImg()
    menu.ensureRoomImg()
    menu.linkRoomImg()

    contactId = menu.getUsername()
    contact = yield sendRPC "getObject", ["contact", contactId]
    contact ?= {}

    menu.insertLocationInput contact.locationNote, (value) ->
      sendRPC("setProperty", ["contact", contactId, "locationNote", value])

    menu.insertNotesArea contact.notes, (value) ->
      sendRPC("setProperty", ["contact", contactId, "notes", value])
