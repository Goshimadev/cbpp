isPlainObject = require "is-plain-object"
isString = require "is-string"

module.exports = deepModify = (object, path, value) ->
  todoStack = makeStack path
  doneStack = []
  numChanges = 0
  while todoStack.length > 1
    propertyName = todoStack.shift()
    doneStack.push propertyName
    if object[propertyName]?
      unless isPlainObject object[propertyName]
        throw new Error "'#{getExpression("object", doneStack)}' is not a plain object."
    else
      object[propertyName] = {}
      numChanges++
    object = object[propertyName]
  propertyName = todoStack.shift()
  unless object[propertyName] is value
    object[propertyName] = value
    numChanges++
  numChanges

makeStack = (path) ->
  if Array.isArray path
    stack = []
    for step in path
      if isString step
        stack.push step
      else
        throw new Error "path array contains a non-string"
    stack
  else if isString path
    if /^[a-z][A-z]*(\.[a-z][A-z]*)*$/.test path
      path.split "."
    else
      throw new Error "Invalid path '#{path}'"
  else
    throw new Error "Supplied path is not a string or an array."

getExpression = (objectName, steps) ->
  expression = objectName
  for step in steps
    if /^[A-z]+$/.test step
      expression += ".#{step}"
    else
      expression += "[#{step.toJSON()}]"
