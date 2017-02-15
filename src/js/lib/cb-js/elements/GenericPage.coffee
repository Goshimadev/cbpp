module.exports = class GenericElement
  type: "generic"
  selectors: {}

  constructor: (document) ->
    @document = document
    @body = document.body

  addClass: (className) ->
    @body.classList.add className

  getUsername: ->
    return "" unless el = @body.querySelector '#user_information a.username'
    return el.textContent
