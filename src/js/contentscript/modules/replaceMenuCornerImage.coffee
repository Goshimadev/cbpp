module.exports =
  name: "replaceMenuCornerImage"

  shouldRun: ({page}) ->
    page.type is "chatRoom"

  run: ({page}) ->
    page.getContextMenuNotifier().on "menuReady", (menu) ->
      menu.replaceCornerImg
        src: "https://i.imgsafe.org/070f11f09e.png",
        width: 16
        height: 16
        style: verticalAlign: "middle"
