closest = require 'closest'
defaults = require 'defaults'

module.exports = activateForm = (formEl, propagate, options = {}) ->
  defaults options,
    errorClass: "error"
    labelSelector: "label"

  for input in formEl.querySelectorAll "input, textarea"
    input.onchange = (event) ->
      value = if event.target.type is "checkbox" then event.target.checked else event.target.value
      label = closest(event.target, options.labelSelector) or event.target
      propagate(event.target.name, value)
        .then -> label.classList.remove options.errorClass
        .then null, -> label.classList.add options.errorClass
