Bluebird = require "bluebird"
docInteractive = require('document-promises').interactive
bindFormToChromeStorage = require "./lib/bind-form-to-chrome-storage.js"
FileReader = require 'promise-file-reader'

renderPopupPage = require "./templates/popup.js"
renderBackupDescription = require "./templates/backupDescription"

bManager = require "./backupManager.js"
triggerDownload = require "./lib/trigger-download"
{alert,confirm} = require("./lib/then-dialogs")(hostname: "CB++")

docInteractive.then ->
  document.body.innerHTML = renderPopupPage()
  form = document.querySelector "form"
  bindFormToChromeStorage form, "devOptions", "local"

  exportButton = document.querySelector '#export'
  exportButton.onclick = Bluebird.coroutine ->
    triggerDownload "CBpp backup #{Date.now()}.json", yield bManager.generateBackup()

  jsonData = undefined

  resultParagraph = document.querySelector "#backupResult"
  descriptionParagraph = document.querySelector '#backupDescription'
  filenameEl = document.querySelector "td h4"
  fileInput = document.querySelector '#import'
  fileInput.addEventListener 'change', (event) ->
    file = fileInput.files[0]
    return unless file.type is "application/json"
    FileReader.readAsText(file)
      .then (result) ->
        jsonData = undefined
        filenameEl.innerText = file.name
        description = bManager.describeBackup result
        jsonData = result
        descriptionParagraph.innerHTML = renderBackupDescription description
      .then null, (error) ->
        jsonData = undefined
        filenameEl.innerText = "[error]"
        descriptionParagraph.innerHTML = "Invalid backup file: #{error.message}"
  restoreButton = document.querySelector '#restore'
  restoreButton.onclick = Bluebird.coroutine ->
    return yield alert "Please select a valid backup file first." unless jsonData
    return unless yield confirm "Are you sure you want to restore the backup? All existing data will be deleted."
    resultParagraph.innerText = "Restoring backup..."
    result = yield bManager.restoreBackup(jsonData).delay(2000)
    resultParagraph.innerText = "Restored #{result.numRecords} records in #{result.elapsedTime} seconds."
