cbjs = require "../lib/cbjs/cbjs"

db = require "./db"

modules = [
  require "./modules/replaceMenuCornerImage"
  require "./modules/devOptions"
  require "./modules/userNotes"
  require "./modules/chatConsoleLogger"
]

module.exports = main = ->
  environment =
    page: cbjs.getPage()
    db: db
  console.log "Logged in on Chaturbate as #{environment.page.getUsername()}"
  for module in modules
    if module.shouldRun environment
      console.log "Starting module #{module.name}"
      module.run environment
