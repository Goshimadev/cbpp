BoldDB = require "../bold-db/bold-db.js"
boldDB = new BoldDB

module.exports = commands =
  getRecord: (recordType, recordId) ->
    boldDB.getRecordManager(recordType).getRecord(recordId)
  getRecordedObject: (recordType, recordId) ->
    boldDB.getRecordManager(recordType).getRecordedObject(recordId)
  setProperty: (recordType, recordId, propertyName, value) ->
    boldDB.getRecordManager(recordType).setProperty(recordId, propertyName, value)
  saveRecord: (recordType, properties) ->
    boldDB.getRecordManager(recordType).saveRecord(recordId, properties)
