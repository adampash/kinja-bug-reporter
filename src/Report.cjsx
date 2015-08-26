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
    xPos: 450
    uploadingImage: false
    reportSubmitted: false

  handleChange: (obj) ->
    @setState obj

  persist: (obj) ->
    chrome.storage.sync.set obj

  cancel: (e) ->
    console.log 'cancel'
    React.unmountComponentAtNode document.querySelector('#kinja_bug_reporter')
    e.preventDefault()
    e.stopPropagation()

  end: (e) ->
    @setState reportSubmitted: true

  recordY: (e) ->
    @setState
      yPos: e.clientY
      xPos: e.clientX

  componentDidMount: ->
    chrome.runtime.onMessage.addListener (request, sender, sendResponse) =>
      @upload(request.image)
      @setState
        screenshots: [request.image, @state.screenshots...]
      , ->
        console.log @state.screenshots.length

  componentWillUnmount: ->
    chrome.runtime.onMessage.removeListener()

  upload: (img) ->
    @setState
      screenshotting: false
      uploadingImage: true
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
        @setState uploadingImage: false

  mailto: ->
    "mailto:bugs@gawker.com?subject=#{"Bug report"}&body=#{encodeURIComponent "## The Bug:\n\n#{@state.description}\n\n## Page details:\n\nURL: #{window.location.href}\nPage title: #{document.title}\n\n## Screenshots:\n\n#{@state.urls.map((url) -> "#{url}").join("\n")}\n\n## User details:\n\nSlack: #{@props.slack or @state.slack}\nKinja: #{@props.kinja or @state.kinja}"}"

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
                    handleBlur={@persist}
                  />
                  <InputGroup
                    name="kinja"
                    label="Your Kinja username"
                    handleChange={@handleChange}
                    handleBlur={@persist}
                  />
                </div>
              </div>
    screenshots = @state.screenshots.map (image, index) ->
      <img src={image} key={index} />
    <Draggable
      zIndex={1000000000000}
      onStop={@recordY}
      handle=".fa-bars"
      bounds="parent"
    >
      <div className={classnames("report", small: @state.screenshotting)} >
        <div className="header">
          <h4>Kinja Bug Report</h4>
          <i className="fa fa-bars"></i>
        </div>
        <div className="content"
          style={maxHeight: @state.window.height - @state.yPos - 40}
        >
        { if @state.reportSubmitted
            <div className="submitted">
              Assuming you emailed the generated bug report, you can <a href="#" onClick={@cancel}>close this bug reporter</a> now. Forgot to press send? <a href={@mailto()}>Try again</a>.
            </div>
          else
            <div>
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
              <div className="screenshot" onClick={@screenshot}>
                <i className="fa fa-camera"></i> Add a screenshot
              </div>
            </div>
            {if @state.uploadingImage
              <div className="submit_group">
                <div className="uploading">
                  <i className="fa fa-spinner fa-pulse"></i> Saving image...
                </div>
              </div>
             else
              <div className="submit_group">
                <a href="#" onClick={@cancel} className="cancel">
                  Cancel
                </a>
                <a href={@mailto()} className="submit" onClick={@end}>
                  Submit a bug
                </a>
              </div>
            }
            </div>
        }
        </div>
      </div>
    </Draggable>

