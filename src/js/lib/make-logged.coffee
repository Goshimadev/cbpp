module.exports = makeLogged = (fn) ->
  ->
    fn.apply(null, arguments)
      .then (result) ->
        console.log result
        result
      .then null, (error) ->
        console.error error
        throw error
