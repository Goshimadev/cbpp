Dialogs = require "dialogs"

module.exports = ThenDialogs = (options) ->
  dialogs = Dialogs options
  thenDialogs = {}
  thenDialogs.cancel = dialogs.cancel.bind dialogs
  thenDialogs[name] = (promisifyDialogFn dialogs[name], dialogs) for name in ['alert', 'prompt', 'confirm']
  thenDialogs

promisifyDialogFn = (fn, dialogs) ->
  ->
    args = (arg for arg in arguments)
    promise = new Promise (resolve, reject) ->
      args.push (result) -> resolve result
      fn.apply dialogs, args
