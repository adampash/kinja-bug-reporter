require './styles/report.scss'
React = require 'react'
Report = require './Report'

child = document.createElement('div')
child.id = "kinja_bug_reporter"
child.setAttribute 'style', "height: #{window.innerHeight}px; position: relative"
document.body.appendChild(child)
window.addEventListener 'resize', ->
  el = document.querySelector('#kinja_bug_reporter')
  el.setAttribute 'style', "height: #{window.innerHeight}px;"


chrome.storage.sync.get ['kinja', 'slack'], (result) ->
  setupComplete = result.kinja? and result.slack?
  React.render(
    <Report
      setupComplete={setupComplete}
      kinja={result.kinja}
      slack={result.slack}
    />,
    document.querySelector('#kinja_bug_reporter')
  )
