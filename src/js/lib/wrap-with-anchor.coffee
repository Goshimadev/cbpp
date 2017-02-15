module.exports = wrapWithAnchor = (element, options = {}) ->
  parentNode = element.parentNode
  nextSibling = element.nextSibling
  anchor = document.createElement "a"
  anchor.href = options.href
  anchor.className = options.className
  anchor.target = options.target
  anchor.rel = options.rel
  anchor.title = options.title
  anchor.appendChild element
  parentNode.insertBefore anchor, nextSibling if parentNode
