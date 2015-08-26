React = require 'react'
Draggable = require 'react-draggable'

module.exports = React.createClass
  getDefaultProps: ->
    type: 'text'

  handleChange: (e) ->
    obj = {}
    obj[@props.name] = e.target.value
    @props.handleChange(obj)

  handleBlur: (e) ->
    return unless @props.name is 'kinja' or @props.name is 'slack'
    obj = {}
    obj[@props.name] = e.target.value
    @props.handleBlur(obj)

  render: ->
    <div>
      <label className="group">
        <div className="label">
          {@props.label}
        </div>
        {if @props.type is 'text'
          <input type="text" onChange={@handleChange} onBlur={@handleBlur} />
         else
          <textarea placeholder={@props.placeholder} onChange={@handleChange} />
        }
      </label>
    </div>
