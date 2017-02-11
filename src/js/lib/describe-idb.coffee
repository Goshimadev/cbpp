module.exports = describeIDB = (db) ->
  name: db.name
  version: db.version
  objectStores: describeObjectStores db

describeObjectStores = (db) ->
  tx = db.transaction db.objectStoreNames, "readonly"
  (describeObjectStore tx.objectStore name for name in db.objectStoreNames)

describeObjectStore = (store) ->
  name: store.name
  keyPath: store.keyPath
  autoIncrement: store.autoIncrement
  indexes: (describeIndex store.index name for name in store.indexNames)

describeIndex = (index) ->
  name: index.name
  keyPath: index.keyPath
  multiEntry: index.multiEntry
  unique: index.unique
