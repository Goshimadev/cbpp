chrome = require "then-chrome"

bodyOptionNames = [
  "hideVideo"
  "hideThumbnails"
  "reduceNoise"
]

module.exports =
  name: "devOptions"

  shouldRun: ->
    true

  run: ({page}) ->
    chrome.storage.local.get(["options","devOptions"]).then ({devOptions}) ->
      devOptions ?= {}
      for optionName in bodyOptionNames
        page.addClass optionName if devOptions[optionName]
