module.exports = sendMessage = (message) ->
  new Promise (resolve, reject) ->
    chrome.runtime.sendMessage message, (response) ->
      if chrome.runtime.lastError
        reject chrome.runtime.lastError
      else
        resolve response
