docInteractive = require('document-promises').interactive
main = require "./contentscript/_main.js"
console.log "CB++ #{chrome.runtime.getManifest().version} has loaded."
docInteractive.then main
