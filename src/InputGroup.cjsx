React = require 'react'
Draggable = require 'react-draggable'

module.exports = React.createClass
  getDefaultProps: ->
    type: 'text'

  handleChange: (e) ->
    obj = {}
    obj[@props.name] = e.target.value
    @props.handleChange(obj)

  render: ->
    <div>
      <label className="group">
        <div className="label">
          {@props.label}
        </div>
        {if @props.type is 'text'
          <input type="text" onChange={@handleChange} />
         else
          <textarea placeholder={@props.placeholder} onChange={@handleChange} />
        }
      </label>
    </div>
