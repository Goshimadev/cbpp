require "chrome-storage-promise"

fillForm = require "./fill-form.js"
activateForm = require "./activate-form.js"

module.exports = bindFormToChromeStorage = (form, objectName, storeName = "sync") ->
  throw new Error "store must be either local, sync or managed" unless storeName in ['local','sync','managed']
  store = chrome.storage.promise[storeName]
  store.get(objectName).then (results) ->
    values = results[objectName] or {}
    propagate = (name, newValue) ->
      values[name] = newValue
      updateRequest = {}
      updateRequest[objectName] = values
      store.set updateRequest
    fillForm form, values
    activateForm form, propagate
