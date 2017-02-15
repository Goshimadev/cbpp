sendRPC = require("../rpcGateway").sendRPC

models =
  contact: require "./models/Contact"

module.exports =
  getRecord: (type, id) ->
    throw new Error "Unknown record type '#{type}'" unless models[type]?
    sendRPC("getRecordedObject", [type, id]).then (properties) => new models[type] @, id, properties

  setProperty: (type, id, name, value) ->
    throw new Error "Unknown record type '#{type}'" unless models[type]?
    sendRPC "setProperty", [type, id, name, value]
