template = require "./templates/popup.js"

docInteractive = require('document-promises').interactive

console.log "CB++ popup code has loaded."
docInteractive.then ->
  document.body.innerHTML = template({})
  console.log "yay"
