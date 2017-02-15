module.exports = class ChatEvent
  constructor: (el) ->
    @el = el
    @innerHTML = @el.innerHTML
    try
      @[name] = value for name, value of (@constructor.parse el)
      @valid = true
    catch error
      @valid = false
      @errorMessage = error.message

ChatEvent.parseUserSpan = (span) ->
  throw new Error "No username found" unless span.matches "span.username"
  sender = {}
  if span.dataset?.nick?
    sender.username = span.dataset.nick
  else if span.textContent.slice(-1) is ":"
    sender.username = span.textContent.slice(0, -1)
  else
    throw new Error "Do not understand #{span.outerHTML}"
  sender

ChatEvent.parseMessageContents = (nodes) ->
  data =
    text: ""
    segments: []
    emoticons: []
  for node in nodes
    switch node.nodeType
      when 3 # TextNode
        data.segments.push node.nodeValue
      when 1 # ElementNode
        emoticon = parseEmoticon node
        data.emoticons.push emoticon
        data.segments.push emoticon.stringValue
      else
        throw new Error "Unexpected node type #{childNode.nodeType}"
  data.text = data.segments.join " "
  data

parseEmoticon = (anchor) ->
  data = {}
  unless anchor.tagName is "A"
    throw new Error "Expected anchor tag"
  unless urlInput = anchor.querySelector 'input[name="image_url"]'
    throw new Error "Could not find image_url input"
  unless urlInput.value
    throw new Error "image_url input has no value"
  data.fullURL = urlInput.value
  unless img = anchor.querySelector 'img'
    throw new Error "Cannot find img element"
  unless img.title
    throw new Error "Image has no title"
  unless matches = img.title.match /^\:([A-z0-9_]+)$/
    throw new Error "misformed value of title attribute"
  unless img.src
    throw new Error "no img src"
  data.smallURL = img.src
  data.name = matches[1]
  data.stringValue = ":#{data.name}"
  data
