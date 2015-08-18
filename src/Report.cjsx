React = require 'react'
Draggable = require 'react-draggable'
InputGroup = require './InputGroup'
Screenshot = require './screenshot'
OnResize = require("react-window-mixins").OnResize
$ = require 'jquery'
classnames = require 'classnames'


module.exports = React.createClass
  mixins: [OnResize]
  getInitialState: ->
    screenshots: []
    urls: []
    screenshotting: false
    yPos: 50

  handleChange: (obj) ->
    @setState obj

  recordY: (e) ->
    @setState yPos: e.clientY

  componentDidMount: ->
    chrome.runtime.onMessage.addListener (request, sender, sendResponse) =>
      @upload(request.image)
      @setState
        screenshots: [request.image, @state.screenshots...]

  upload: (img) ->
    $.ajax
      method: "POST"
      url: "https://buploader.herokuapp.com/uploader"
      data:
        image: img
      success: (response) =>
        @setState
          urls: [response.url, @state.urls...]
      error: (e) ->
        alert('Something went wrong')
      complete: =>
        @setState screenshotting: false
        console.log 'image uploaded'

  mailto: ->
    "mailto:bugs@gawker.com?subject=#{"Bug report"}&body=#{encodeURIComponent "## The Bug:\n\n#{@state.description}\n\n## Page details:\n\nURL: #{window.location.href}\nPage title: #{document.title}\n\n## Screenshots:\n\n#{@state.urls.map (url) -> "#{url}\n"}\n\n## User details:\n\nSlack: #{@state.slack}"}"

  screenshot: ->
    Screenshot.startScreenshot()
    @setState
      screenshotting: true

  render: ->
    unless @props.setupComplete
      setup = <div className="section">
                <h4>Your info (you'll only have to enter these once)</h4>
                <div className="inputs">
                  <InputGroup
                    name="slack"
                    label="Your Slack username"
                    handleChange={@handleChange}
                  />
                  <InputGroup
                    name="kinja"
                    label="Your Kinja username"
                    handleChange={@handleChange}
                  />
                </div>
              </div>
      screenshots = @state.screenshots.map (image, index) ->
        <img src={image} key={index} />
    <Draggable
      zIndex={1000000000000}
      onStop={@recordY}
    >
      <div className={classnames("report", small: @state.screenshotting)}
        style={maxHeight: @state.window.height - @state.yPos - 50}
      >
        <h4>Kinja Bug Report</h4>
        {setup}
        <h4>The Bug</h4>
        <InputGroup
          name="description"
          handleChange={@handleChange}
          type="textarea"
          label="Describe the bug"
          placeholder="What's the bug? When did the issue start? Has anyone else on your staff experienced the issue? Etc."
        />
        <div className="group">
          <div className="screenshots screenshot">
            {screenshots}
          </div>
        </div>
        <div className="group">
          <button className="screenshot" onClick={@screenshot}>
            Attach a screenshot
          </button>
        </div>
        <div className="group">
          <a href={@mailto()}>
            <button className="submit" onClick={@submit}>
              Submit a bug
            </button>
          </a>
        </div>
      </div>
    </Draggable>

