startPos = {}
startY = null
ghostElement = null
started = false
i = 0

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
        return if e.target.className is "fa fa-arrows"
        @mouseDown(e)
      when 'keydown'
        @keyDown(e)
      when 'mousemove'
        @mouseMove(e)
      when 'mouseup'
        @mouseUp(e)


  endScreenshot: (coords) ->
    started = false
    console.log coords
    if window.matchMedia("(-webkit-device-pixel-ratio: 2)").matches
      coords.x = coords.x * 2
      coords.y = coords.y * 2
      coords.w = coords.w * 2
      coords.h = coords.h * 2
    document.removeEventListener('mousedown', @, false)
    document.removeEventListener('keydown', @, false)
    document.removeEventListener('mousemove', @, false)
    document.removeEventListener('mouseup', @, false)

    @sendMessage({type: 'coords', coords: coords})

  sendMessage: (msg) ->
    # change cursor back to default
    document.body.style.cursor = 'default'

    console.log('sending message with screenshoot')
    console.log "MSG:", msg
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

    if diff.x < 0
      ghostElement.style.right = window.innerWidth - startPos.x + 'px'
      ghostElement.style.left = 'auto'
    else
      ghostElement.style.left = startPos.x + 'px'
      ghostElement.style.right = 'auto'
    if diff.y < 0
      ghostElement.style.bottom = window.innerHeight - startPos.y + 'px'
      ghostElement.style.top = 'auto'
    else
      ghostElement.style.top = startPos.y + 'px'
      ghostElement.style.bottom = 'auto'

    ghostElement.style.width = Math.abs(diff.x) + 'px'
    ghostElement.style.height = Math.abs(diff.y) + 'px'

    return false


  mouseUp: (e) ->
    return unless started
    e.preventDefault()

    nowPos = {x: e.pageX, y: e.pageY}
    diff = {x: nowPos.x - startPos.x, y: nowPos.y - startPos.y - window.scrollY}
    if diff.x is 0 or diff.y is 0
      startPos =
        x: 0
      startY = 0
      diff =
        x: window.innerWidth
        y: window.innerHeight

    ghostElement.parentNode.removeChild(ghostElement)
    setTimeout =>
      coords = {}

      coords.w = @pxToInt ghostElement.style.width
      coords.h = @pxToInt ghostElement.style.height
      if startPos.x < nowPos.x
        coords.x = e.x - coords.w
        console.log 'yes'
      else
        coords.x = e.x
      if startPos.y < nowPos.y
        coords.y = e.y - coords.h
        console.log 'yes'
      else
        coords.y = e.y

      gCoords = coords

      e.stopPropagation()
      @endScreenshot(coords)
    , 50

    return false

  pxToInt: (val) ->
    parseInt val.substr(0, val.length - 2)
