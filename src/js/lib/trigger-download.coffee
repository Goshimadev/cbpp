createDownloadLink = require 'create-download-link'

module.exports = triggerDownload = (filename, data) ->
  anchor = createDownloadLink
    data: data
    title: "download"
    filename: filename
  anchor.click()
