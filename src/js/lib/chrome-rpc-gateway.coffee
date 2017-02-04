module.exports = class ChromeRPCGateway
  constructor: (commands, explicitChrome) ->
    @commands = commands
    @runtime = if explicitChrome then explicitChrome.runtime else chrome.runtime

  listen: ->
    @runtime.onMessage.addListener (msg, sender, sendResponse) =>
      return unless msg.type is "RPC"
      @getResponseForRPCMessage(msg,sender).then (response) ->
        console.log response
        sendResponse response
      true

  getResponseForRPCMessage: (msg, sender) ->
    @processRPCMessage(msg, sender)
      .then (result) ->
        type: "RPC Result"
        data: result
      .then null, (error) ->
        type: "Error"
        data:
          name: error.name
          message: error.message
          stack: error.stack

  processRPCMessage: (msg, sender) ->
    try
      return Promise.reject new MessageError "No data field" unless msg.data
      return Promise.reject new MessageError "No RPC method" unless msg.data.method
      return Promise.reject new MessageError "Unknown method '#{msg.data.method}'" unless @commands[msg.data.method]
      return @honorRPC(msg.data.method, msg.data.params, sender).then null, (error) ->
        throw new InternalError error.message
    catch error then Promise.reject new InternalError error.message

  sendRPC: (method, params) =>
    throw new Error "Unknown method #{method}" unless @commands[method]
    @sendMessage(@makeRPCMessage(method, params)).then (responseMessage) ->
      switch responseMessage.type
        when "RPC Result" then return responseMessage.data
        when "Error"
          error = new ReceivedRPCError responseMessage.data.message
          error.remoteName = responseMessage.data.name
          error.remoteStack = responseMessage.data.stack
          console.error error
          throw error
        else throw new Error "Unexpected message type #{responseMessage.type}"

  makeRPCMessage: (method, params) ->
    type: "RPC"
    data:
      method: method
      params: params

  honorRPC: (method, params, sender) ->
    console.log "Doing RPC #{method} with params #{params.toString()}"
    (@commands[method].apply undefined, params).then null, (error) ->
      console.log "Error when executing command: #{error.name}: #{error.message}"
      throw new RPCError error.message

  sendMessage: (message) ->
    new Promise (resolve, reject) =>
      @runtime.sendMessage message, (response) =>
        if @runtime.lastError then reject @runtime.lastError else resolve response

class CustomError extends Error
  constructor: (message) ->
    Error.captureStackTrace @, @constructor
    @name = @constructor.name
    @message = message

class ReceivedRPCError extends CustomError
class RPCError extends CustomError
class InternalError extends CustomError
class MessageError extends CustomError
