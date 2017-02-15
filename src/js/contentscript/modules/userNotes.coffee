wrapWithAnchor = require "../../lib/wrap-with-anchor"

module.exports =
  name: "userNotes"

  shouldRun: ({page}) ->
    page.type is "chatRoom"

  run: ({page,db}) ->
    page.getContextMenuNotifier().on "menuReady", (menu) ->
      db.getRecord("contact", menu.username).then (contact) ->
        contact.increaseCounter "menuOpened"

        menu.insertRoomImg menu.get("genderImg").src unless menu.get "roomImg"

        roomImg = menu.get "roomImg"
        roomImg.classList.add "submenu_profile_roomimg"
        wrapWithAnchor roomImg, href: @userProfileURL

        menu.replaceProfileAnchor createInput
          className: "ppUserLocationNote"
          placeholder: "Unknown"
          value: contact.getProperty "locationNote"
          callback: (value) -> contact.setProperty "locationNote", value
        menu.extendProfileInfo createInput
          type: "textarea"
          className: "ppUserNotes"
          placeholder: "No notes yet."
          value: contact.getProperty "notes"
          callback: (value) -> contact.setProperty "notes", value

createInput = ({type, className, placeholder, value, callback}) ->
  type = "input" unless type is "textarea"
  input = document.createElement type
  input.className = className
  input.value = if value? then value else ""
  input.placeholder = placeholder
  input.onblur = ->
    callback(input.value)
      .then -> input.classList.remove "ppUpdateError"
      .then null, -> input.classList.add "ppUpdateError"
  input
