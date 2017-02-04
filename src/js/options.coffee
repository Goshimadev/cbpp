template = require "./templates/options.js"

docInteractive = require('document-promises').interactive

console.log "CB++ options code has loaded."
docInteractive.then ->
  document.body.innerHTML = template({})
