module.exports = linkElement = (el, href) ->
  anchor = document.createElement "a"
  anchor.href = href
  el.parentNode.insertBefore anchor, el
  anchor.appendChild el
