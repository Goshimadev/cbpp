Bluebird = require "bluebird"

module.exports = upgradeDB = Bluebird.coroutine (db) ->
  try
    throw new Error "Not safe to upgrade" unless isSafeToUpgrade db.oldVersion, db.version
    console.log "Upgrading db #{db.name} from v#{db.oldVersion} to v#{db.version}"
    yield reallyUpgradeDB db
  catch error
    console.log "Error while upgrading database, aborting transaction"
    db.transaction.abort()
    throw error

isSafeToUpgrade = (oldVersion, newVersion) ->
  return true

reallyUpgradeDB = Bluebird.coroutine (db) ->
  yield Bluebird.resolve()
  if db.oldVersion < 6
    db.createObjectStore 'contacts', keyPath: "id"
  if db.oldVersion < 8
    contactStore = db.transaction.objectStore "contacts"
    contacts = yield contactStore.getAll()
    yield contactStore.put(upgradeContact contact) for contact in contacts
    contactStore.createIndex "createdAt", "createdAt"
    contactStore.createIndex "modifiedAt", "modifiedAt"

upgradeContact = (contact) ->
  id: contact.id
  createdAt: (now = new Date).toJSON()
  modifiedAt: now.toJSON()
  modifiedCount: 1
  properties:
    locationNote: contact.locationNote
    notes: contact.notes
