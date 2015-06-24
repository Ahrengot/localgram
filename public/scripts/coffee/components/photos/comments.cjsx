React = require 'react'
_ = require 'underscore'

Comments = React.createClass
	renderComment: (comment) ->
		<div key={ comment.id } className="media comment">
			<div className="media-left">
				<img className="media-object" src={ comment.from.profile_picture } width="30" height="30" />
			</div>
			<div className="media-body">
				<h6 className="media-heading">{ comment.from.full_name }</h6>
				<p>{ comment.text }</p>
			</div>
		</div>
	render: ->
		<div className="comments media-list">
			{ _.map( @props.comments, @renderComment ) }
		</div>

module.exports = Comments