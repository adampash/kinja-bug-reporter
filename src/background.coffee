console.log 'load'
tab = null
chrome.browserAction.onClicked.addListener (_tab) ->
  tab = _tab
  console.log('clicked')
  # chrome.tabs.insertCSS({file: "styles/main.css"})

  # for the current tab, inject the "reporter.js" file & execute it
  chrome.tabs.executeScript(tab.ib, {
    file: 'reporter.js'
  })

cropData = (str, coords, callback) ->
  img = new Image()

  img.onload = ->
    canvas = document.createElement('canvas')
    canvas.width = coords.w
    canvas.height = coords.h
    ctx = canvas.getContext('2d')
    ctx.drawImage img, coords.x, coords.y, coords.w, coords.h, 0, 0, coords.w, coords.h
    callback dataUri: canvas.toDataURL()
    return

  img.src = str

capture = (coords) ->
  chrome.tabs.captureVisibleTab(null, {"format": "png"}, (dataUrl) ->
    cropData dataUrl, coords, (data) ->
      chrome.tabs.sendMessage(tab.id, {image: data.dataUri})
    )

chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
  console.log('got message!')
  if (request.type == "coords")
    capture(request.coords)
