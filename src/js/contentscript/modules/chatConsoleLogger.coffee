module.exports =
  name: "chatConsoleLogger"
  shouldRun: ({page}) ->
    page.type is "chatRoom"

  run: ({page}) ->
    notifier = page.getChatEventNotifier()
    notifier.on "message", (message) ->
      console.log message.toString()
    notifier.on "line", (line) ->
      if line.type in ["other","other-paragraph"]
        alert "Unknown line: #{line.el.textContent}"
        console.log "Unknown line: #{line.el.textContent}"
        console.log line

    notifier.on "tip", (tip) ->
      console.log message
    notifier.on "removedLine", (line) =>
      return if line.type is "message" # expected when a user is silenced
      console.error "UNEXPECTED ELEMENT REMOVED: #{el.textContent}"
