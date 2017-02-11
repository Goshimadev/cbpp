pluralize = require "pluralize"

module.exports = class RecordManager
  constructor: (getDB, recordType) ->
    @recordType = recordType
    @storeName = pluralize recordType
    @getDB = getDB

  getRecord: (recordId) ->
    @getDB().then (db) =>
      tx = db.transaction @storeName, "readonly"
      store = tx.objectStore @storeName
      store.get recordId

  getRecordedObject: (recordId) ->
    @getRecord(recordId).then (record) -> if record? then record.properties else null

  saveRecord: (recordId, properties) ->
    @getDB().then (db) =>
      tx = db.transaction @storeName, "readwrite"
      store = tx.objectStore @storeName
      ensureRecord(store, recordId).then (record) ->
        record.properties = properties
        record.modifiedCount++
        record.modifiedAt = new Date
        store.put record

  setProperty: (recordId, propertyName, value) ->
    @getDB().then (db) =>
      tx = db.transaction @storeName, "readwrite"
      store = tx.objectStore @storeName
      ensureRecord(store, recordId).then (record) ->
        return false if record.properties[propertyName] is value
        record.properties[propertyName] = value
        record.modifiedCount++
        record.modifiedAt = new Date
        store.put record
        true

ensureRecord = (store, recordId) ->
  store.get(recordId).then (record) -> if record then record else createRecord recordId

createRecord = (id) ->
  id: id
  createdAt: new Date
  modifiedAt: new Date
  modifiedCount: -1
  properties: {}
