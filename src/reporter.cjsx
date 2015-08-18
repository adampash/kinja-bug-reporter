require './styles/report.scss'
React = require 'react'
Report = require './Report'

child = document.createElement('div')
child.id = "kinja_bug_reporter"
document.body.appendChild(child)

React.render(
  <Report setupComplete={false} />,
  document.querySelector('#kinja_bug_reporter')
)
