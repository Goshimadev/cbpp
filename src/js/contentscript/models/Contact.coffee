module.exports = class Contact
  constructor: (@db, @id, @properties) ->
    @properties ?= {}
    @properties.counters

  getProperty: (name) ->
    @properties[name]

  setProperty: (name, value) ->
    @db.setProperty "contact", @id, name, value

  increaseCounter: (name) ->
    @properties.counters ?= {}
    @properties.counters[name] ?=0
    @properties.counters[name]++
    @setProperty "counters.#{name}", @properties.counters[name]
