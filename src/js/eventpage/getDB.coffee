Bluebird = require "bluebird"
idb = require "idb"

describeDB = require "../lib/describe-idb.js"

upgradeDB = require "./upgradeDB.js"

dbName = "cbpp"
dbVersion = 7

cachedDB = undefined
module.exports = getDB = -> cachedDB ?= openDB()

openDB = ->
  idb.open(dbName, dbVersion, upgradeDB).then (db) ->
    console.log "Opened DB #{db.name} v#{db.version}"
    console.log JSON.stringify (describeDB db), null, 2
    Bluebird.delay 1, db
