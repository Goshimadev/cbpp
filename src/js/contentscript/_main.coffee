require "chrome-storage-promise"

chromeStorage = chrome.storage.promise.local

delay = require "call-delayed"
Bluebird = require "bluebird"

makeLogged = require "../lib/make-logged.js"

page = require "./currentPage.js"
sendRPC = require("../rpcGateway.js").sendRPC
sendRPC = makeLogged sendRPC

module.exports = main = Bluebird.coroutine ->
  {options,devOptions} = yield chromeStorage.get ["options","devOptions"]
  options ?= {}
  document.body.classList.add "hideVideo" if devOptions.hideVideo
  document.body.classList.add "hideThumbnails" if devOptions.hideThumbnails


  console.log "CB++ is running."
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
    contact = {} unless contact

    menu.insertLocationInput contact.locationNote, (value) ->
      sendRPC("setProperty", ["contact", contactId, "locationNote", value])

    menu.insertNotesArea contact.notes, (value) ->
      sendRPC("setProperty", ["contact", contactId, "notes", value])
