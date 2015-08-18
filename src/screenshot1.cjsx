React = require 'react'
startPos = {}
startY = null
ghostElement = null

module.exports = React.createClass
  displayName: "Screenshot"
  getInitialState: ->
    started: false

  startScreenshot: ->
    @setState
      started: true
    console.log('start screenshot')
    # change cursor
    # document.body.style.cursor = 'crosshair'

    # document.addEventListener('mousedown', @mouseDown, false)
    # document.addEventListener('keydown', @keyDown, false)

  endScreenshot: (coords) ->
    document.removeEventListener('mousedown', @mouseDown, false)

    @sendMessage({type: 'coords', coords: coords})

  sendMessage: (msg) ->
    # change cursor back to default
    document.body.style.cursor = 'default'

    console.log('sending message with screenshoot')
    chrome.runtime.sendMessage(null, msg, null, (response) ->)

  # // end messages

  keyDown: (e) ->
    return unless @state.started
    keyCode = e.keyCode

    # Hit: n
    if ( keyCode == '78' && gCoords )
      e.preventDefault()
      e.stopPropagation()

      @endScreenshot(gCoords)

      return false


  mouseDown: (e) ->
    @startScreenshot() unless @state.started
    e.preventDefault()

    startPos = {x: e.pageX, y: e.pageY}
    startY = e.y

    ghostElement = document.createElement('div')
    ghostElement.style.background = 'blue'
    ghostElement.style.opacity = '0.1'
    ghostElement.style.position = 'absolute'
    ghostElement.style.left = e.pageX + 'px'
    ghostElement.style.top = e.pageY + 'px'
    ghostElement.style.width = "0px"
    ghostElement.style.height = "0px"
    ghostElement.style.zIndex = "1000000"
    document.body.appendChild(ghostElement)

    document.addEventListener('mousemove', @mouseMove, false)
    document.addEventListener('mouseup', @mouseUp, false)

    return false


  mouseMove: (e) ->
    return unless @state.started
    console.log 'mousemove'
    e.preventDefault()

    nowPos = {x: e.pageX, y: e.pageY}
    diff = {x: nowPos.x - startPos.x, y: nowPos.y - startPos.y}

    ghostElement.style.width = diff.x + 'px'
    ghostElement.style.height = diff.y + 'px'

    return false


  mouseUp: (e) ->
    return unless @state.started
    console.log 'mouseup'
    e.preventDefault()

    nowPos = {x: e.pageX, y: e.pageY}
    diff = {x: nowPos.x - startPos.x, y: nowPos.y - startPos.y}

    document.removeEventListener('mousemove', @mouseMove, false)
    document.removeEventListener('mouseup', @mouseUp, false)

    ghostElement.parentNode.removeChild(ghostElement)

    setTimeout ->
      coords = {
        w: diff.x,
        h: diff.y,
        x: startPos.x,
        y: startY
      }
      gCoords = coords
      @endScreenshot(coords)
    , 50

    return false

  render: ->
    <div className="screenshot_overlay"
      onMouseDown={@mouseDown}
      onMouseUp={@mouseUp}
      onMouseMove={@mouseMove}
      onKeyDown={@keyDown}
    />
