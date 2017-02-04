docInteractive = require('document-promises').interactive
main = require "./contentscript/_main.js"
console.log "CB++ has loaded."
docInteractive.then main
