Bluebird = require "bluebird"
chrome = require "then-chrome"
getDB = require "./getDB.js"

module.exports =
  parseBackup: (fileContents) ->
    try
      {type,data} = JSON.parse fileContents
    catch error
      throw new Error "Backup file is malformed: #{error.message}"
    throw new Error "Not a CB++ backup file" unless type is "CB++ backup file"
    throw new Error "No data" unless data
    throw new Error "Unepexected version #{data.version}" unless data.version is 1
    throw new Error "No data" unless data.data?
    throw new Error "No contacts array" unless data.data.contacts?
    throw new Error "No contacts array" unless Array.isArray data.data.contacts
    data

  describeBackup: (fileContents) ->
    data = @parseBackup fileContents
    return description =
      generatedAt: new Date data.generatedAt
      numContacts: data.data.contacts.length

  restoreBackup: Bluebird.coroutine (fileContents) ->
    start = Date.now()
    db = yield getDB()
    {data} = @parseBackup fileContents
    tx = db.transaction "contacts", "readwrite"
    contactStore = tx.objectStore "contacts"
    contactStore.clear()
    yield contactStore.add contact for contact in data.contacts
    yield tx.complete
    end = Date.now()
    return result =
      completedAt: new Date
      elapsedTime: ((end-start)/1000).toFixed(3)
      numContacts: data.contacts.length
      numRecords: data.contacts.length

  generateBackup: Bluebird.coroutine ->
    db = yield getDB()
    extensionInfo = yield chrome.management.getSelf()
    data =
      type: "CB++ backup file"
      data:
        version: 1
        idbVersion: db.version
        cbppInstallType: extensionInfo.installType
        cbppVersion: extensionInfo.version
        generatedAt: (new Date).toISOString()
        data:
          contacts: yield db.transaction("contacts").objectStore("contacts").getAll()
    fileContents = JSON.stringify(data, null, 2) + "\n"
    @parseBackup fileContents
    fileContents
