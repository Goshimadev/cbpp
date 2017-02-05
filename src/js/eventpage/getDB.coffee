idb = require "idb"
dbUpgrade = require "./dbUpgrade.js"

dbName = "cbpp"
dbVersion = 2

cachedDB = undefined
module.exports = getDB = -> cachedDB ?= openDB()

openDB = ->
  idb.open(dbName, dbVersion, upgrader).then (db) ->
    console.log "Opened db #{db.name} version #{db.version}."
    names = (name for name in db.objectStoreNames)
    console.log "Available object stores: #{names}"
    db

upgrader = (db) ->
  if dbUpgrade[db.oldVersion]?
    dbUpgrade[db.oldVersion](db)
  else
    throw new Error "No upgrade possible from db #{db.name} version #{db.oldVersion}."
