module.exports = class GenericElement
  get: (name) ->
    throw new Error "unknown element #{name}" unless @selectors[name]?
    @el.querySelector @selectors[name]
