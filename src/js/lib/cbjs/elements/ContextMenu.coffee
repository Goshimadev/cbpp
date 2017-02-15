GenericElement = require "./GenericElement"

module.exports = class ContextMenu extends GenericElement
  selectors:
    profileDiv:     "div.submenu_profile"
    roomImg:        "div.submenu_profile > img"
    profileInfoDiv: "div.submenu_profile > div.submenu_profile_info"
    profileAnchor:  "div.submenu_profile > div.submenu_profile_info > a"
    genderImg:      "div.submenu_profile > div.submenu_profile_info > img"
    usernameEl:     "p.jscontextLabel"
    cornerImage:    "p.jscontextLabel > img"

  constructor: (el) ->
    @el = el
    @userProfileURL = @get("profileAnchor")?.href
    throw new Error "userProfileURL cannot be empty" unless @userProfileURL
    @username = @get("usernameEl")?.textContent.trim()
    throw new Error "username cannot be empty" unless @username

  insertRoomImg: (src) ->
    throw new Error "There's already a room img" if @get "roomImg"
    img = document.createElement "img"
    img.src = src
    img.width = 62
    img.height = 52
    @get("profileDiv").insertBefore img, @get("profileInfoDiv")

  replaceCornerImg: ({src, width, height, style})->
    img = @get "cornerImage"
    img.src = src
    img.width = width
    img.height = height
    img.style[name] = value for name, value of style

  replaceProfileAnchor: (el) ->
    profileAnchor = @get "profileAnchor"
    profileAnchor.parentNode.insertBefore el, profileAnchor
    profileAnchor.remove()

  extendProfileInfo: (el) ->
    @get("profileInfoDiv").appendChild el
