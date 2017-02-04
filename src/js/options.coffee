require "chrome-storage-promise"

docInteractive = require('document-promises').interactive
Bluebird = require "bluebird"

fillForm = require "./lib/fill-form.js"
activateForm = require "./lib/activate-form.js"

template = require "./templates/options.js"

storage = chrome.storage.promise

console.log "CB++ options code has loaded."

docInteractive.then Bluebird.coroutine ->
  {options} = (yield storage.local.get "options") or {}
  propagate = (name, newValue) ->
    options[name] = newValue
    storage.local.set options: options
  document.body.innerHTML = template()
  form = document.body.querySelector "form"
  fillForm form, options
  activateForm form, propagate
