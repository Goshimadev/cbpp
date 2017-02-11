recordTypes = ["contact"]
RecordManager = require "./record-manager.js"

getDB = require "./getDB.js"

module.exports = class BoldDB
  constructor: ->
    @getDB = getDB

  getRecordManager: (recordType) ->
    throw new Error "Unknown record type #{recordType}" unless recordType in recordTypes
    new RecordManager @getDB, recordType
