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
  return true if oldVersion is 0
  return true if oldVersion >= 6
  return false

reallyUpgradeDB = Bluebird.coroutine (db) ->
  yield Bluebird.resolve()
  if db.oldVersion < 2
    db.createObjectStore 'contacts'
  if db.oldVersion < 6
    db.deleteObjectStore 'contacts'
    db.createObjectStore 'contacts', keyPath: "id"
