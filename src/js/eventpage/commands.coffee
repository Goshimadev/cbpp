Bluebird = require "bluebird"
pluralize = require "pluralize"

getDB = require "../getDB.js"

module.exports = commands =
  getObject: Bluebird.coroutine (objectType, objectId) ->
    storeName = pluralize objectType
    db = yield getDB()
    tx = db.transaction storeName, "readonly"
    store = tx.objectStore storeName
    store.get objectId
  setProperty: Bluebird.coroutine (objectType, objectId, propertyName, value) ->
    throw new Error "Cannot replace property 'id'" if propertyName is "id"
    storeName = pluralize objectType
    db = yield getDB()
    tx = db.transaction storeName, "readwrite"
    store = tx.objectStore storeName
    object = {id: objectId } unless object = yield store.get objectId
    object[propertyName] = value
    console.log "Attempting put(#{JSON.stringify(object)},'#{objectId}')"
    store.put object
  saveObject: Bluebird.coroutine (objectType, value) ->
    storeName = pluralize objectType
    db = yield getDB()
    tx = db.transaction storeName, "readwrite"
    store = tx.objectStore storeName
    store.put value
  clearObjectStore: Bluebird.coroutine (objectType) ->
    storeName = pluralize objectType
    db = yield getDB()
    tx = db.transaction storeName, "readwrite"
    store = tx.objectStore storeName
    store.clear()
  deleteObject: Bluebird.coroutine (objectType, objectId) ->
    storeName = pluralize objectType
    db = yield getDB()
    tx = db.transaction storeName, "readwrite"
    store = tx.objectStorestoreName
    store.delete objectId
