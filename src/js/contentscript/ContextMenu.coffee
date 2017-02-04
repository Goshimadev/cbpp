insertAfter = require "insert-after"

ChildListChangeNotifier = require './ChildListChangeNotifier.js'
linkElement = require '../lib/link-dom-element.js'

module.exports = class ContextMenu
  constructor: (el) ->
    @el = el
    @notifier = new ChildListChangeNotifier @el, true
    @replaceCornerImg el

  querySelector: (query) ->
    @el.querySelector query

  getUsername: ->
    return "" unless el = @querySelector ".jscontextLabel"
    return el.innerText

  insertNotesArea: (value, cb) ->
    textarea = createInput "textarea", "ppUserNotes", "No notes.", value, cb
    profileInfoEl = @querySelector "div.submenu_profile_info"
    profileInfoEl.appendChild textarea

  insertLocationInput: (value, cb) ->
    input = createInput "input", "ppUserLocationNote", "Unknown.", value, cb
    insertAfter input, @querySelector "div.submenu_profile > div.submenu_profile_info > img"

  linkRoomImg: ->
    userAnchor = @querySelector "div.submenu_profile > div.submenu_profile_info > a"
    roomImg = @querySelector "div.submenu_profile > img"
    roomImg.classList.add "submenu_profile_roomimg"
    linkElement roomImg, userAnchor.href
    userAnchor.remove()

  ensureRoomImg: ->
    @insertRoomImg() unless @querySelector "div.submenu_profile > img"

  insertRoomImg: ->
    genderImg = @querySelector "div.submenu_profile > div.submenu_profile_info > img"
    submenuElement = @querySelector "div.submenu_profile"
    infoElement = @querySelector "div.submenu_profile_info"
    img = document.createElement "img"
    img.src = genderImg.src
    img.width = 62
    img.height = 52
    submenuElement.insertBefore img, infoElement

  replaceCornerImg: ->
    img = @querySelector "img"
    img.src = "https://i.imgsafe.org/070f11f09e.png"
    img.width = 16
    img.height = 16
    img.style.verticalAlign = "middle"

createInput = (tagName, className, placeholder, value, cb) ->
  input = document.createElement tagName
  input.className = className
  input.value = if value? then value else ""
  input.placeholder = placeholder
  input.onblur = ->
    cb(input.value)
      .then -> input.classList.remove "ppUpdateError"
      .then null, -> input.classList.add "ppUpdateError"
  input
