module.exports =
  "0": (db) ->
    db.createObjectStore 'contacts'
  "1": (db) ->
    db.deleteObjectStore 'contacts'
    db.createObjectStore 'contacts', keyPath: "id"
