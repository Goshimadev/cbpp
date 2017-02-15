EventEmitter = require("events").EventEmitter

MutationNotifier = require '../dom-mutation-notifier'

ChatLine = require "./chat-events/ChatLine"

chatEventConstructors =
  message: require "./chat-events/Message"
  tip: require "./chat-events/Tip"

module.exports = class ChatEventNotifier
  constructor: (el) ->
    @el = el
    @emitter = new EventEmitter
    @notifier = new MutationNotifier el
    @trackedEvents = []

  on: (eventName, eventListener) ->
    @ensureTracked eventName
    @emitter.on eventName, eventListener

  isTracked: (eventName) ->
    eventName in @trackedEvents

  ensureTracked: (eventName) ->
    @track eventName unless @isTracked eventName

  track: (eventName) ->
    if eventName is "line"
      @notifier.on "elementAdded", (el) => @emitter.emit "line", new ChatLine el
    else if eventName is "removedLine"
      @notifier.on "elementRemoved", (el) => @emitter.emit "removedLine", new ChatLine el
    else if EventConstructor = chatEventConstructors[eventName]
      @emitter.on "line", (line) =>
        return unless line.type is eventName
        return @emitter.emit eventName, new EventConstructor line.el
    else
      throw new Error "Cannot track event '#{eventName}'"
    @trackedEvents.push eventName
