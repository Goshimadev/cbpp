module.exports = fillForm = (formEl, values) ->
  for input in formEl.querySelectorAll "input, textarea"
    if input.type is "checkbox"
      input.checked = if values[input.name] then true else false
    else
      input.value = values[input.name]
