RPCGateway = require "./lib/chrome-rpc-gateway.js"
commands = require "./eventpage/commands.js"
module.exports = new RPCGateway commands
