startPos = {}
startY = null
ghostElement = null
started = false

module.exports =
  startScreenshot: ->
    console.log('start screenshot')
    # change cursor
    document.body.style.cursor = 'crosshair'

    # document.addEventListener('mousedown', @mouseDown, false)
    document.addEventListener('mousedown', @, false)
    document.addEventListener('keydown', @, false)
    document.addEventListener('mousemove', @, false)
    document.addEventListener('mouseup', @, false)

  handleEvent: (e) ->
    switch e.type
      when 'mousedown'
        @mouseDown(e)
      when 'keydown'
        @keyDown(e)
      when 'mousemove'
        @mouseMove(e)
      when 'mouseup'
        @mouseUp(e)


  endScreenshot: (coords) ->
    started = false
    document.removeEventListener('mousedown', @, false)
    document.removeEventListener('keydown', @, false)
    document.removeEventListener('mousemove', @, false)
    document.removeEventListener('mouseup', @, false)

    @sendMessage({type: 'coords', coords: coords})

  sendMessage: (msg) ->
    # change cursor back to default
    document.body.style.cursor = 'default'

    console.log('sending message with screenshoot')
    chrome.runtime.sendMessage(null, msg, null, (response) ->)

  # // end messages

  keyDown: (e) ->
    return unless started
    keyCode = e.keyCode

    # Hit: n
    if ( keyCode == '78' && gCoords )
      e.preventDefault()
      e.stopPropagation()

      @endScreenshot(gCoords)

      return false


  mouseDown: (e) ->
    started = true
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


    return false


  mouseMove: (e) ->
    return unless started
    e.preventDefault()

    nowPos = {x: e.pageX, y: e.pageY}
    diff = {x: nowPos.x - startPos.x, y: nowPos.y - startPos.y}

    ghostElement.style.width = diff.x + 'px'
    ghostElement.style.height = diff.y + 'px'

    return false


  mouseUp: (e) ->
    return unless started
    e.preventDefault()

    nowPos = {x: e.pageX, y: e.pageY}
    diff = {x: nowPos.x - startPos.x, y: nowPos.y - startPos.y}

    ghostElement.parentNode.removeChild(ghostElement)

    setTimeout =>
      coords = {
        w: diff.x,
        h: diff.y,
        x: startPos.x,
        y: startY
      }
      gCoords = coords
      e.stopPropagation()
      @endScreenshot(coords)
    , 50

    return false
