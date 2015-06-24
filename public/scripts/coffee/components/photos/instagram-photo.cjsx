React = require 'react'
_ = require 'underscore'
Moment = require 'moment'

Comments = require './comments'

rad = (x) ->
  return x * Math.PI / 180

# http://stackoverflow.com/questions/1502590/calculate-distance-between-two-points-in-google-maps-v3
distanceBetweenPoints = (p1, p2) ->
	R = 6378137 # Earth’s mean radius in meter
	dLat = rad(p2.latitude - p1.latitude)
	dLong = rad(p2.longitude - p1.longitude)
	a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +

	Math.cos(rad(p1.latitude)) * Math.cos(rad(p2.latitude)) *
	Math.sin(dLong / 2) * Math.sin(dLong / 2)

	c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
	d = R * c
	return d # returns the distance in meter

InstagramPhoto = React.createClass
	getRelativeTime: (timestamp) ->
		Moment( timestamp * 1000 ).fromNow()
	getLocationStr: ->
		meters = Math.round distanceBetweenPoints(@props.userCoords, @props.location)
		distanceStr = (meters / 1000).toFixed(2) + "km"
		if @props.location.name
			distanceStr += " (#{@props.location.name})"
		return distanceStr
	renderComments: ->
		<Comments comments={ @props.data.comments.data } />
	render: ->
		<div className="instagram-photo">
			<a href={ @props.data.link } target="_blank">
				<img className="image" src={ @props.images.standard_resolution.url } alt={ @props.data.caption?.text } />
			</a>

			<div className="media user-profile">
				<div className="media-left">
					<img className="media-object" src={ @props.user.profile_picture } width="30" height="30" />
				</div>
				<div className="media-body">
					<h6 className="media-heading">{ @props.user.full_name }</h6>
					<p>{ @props.data.caption?.text }</p>
					<ul className="photo-meta list-inline">
						<li><span className="glyphicon glyphicon-time"></span> { @getRelativeTime @props.data.created_time }</li>
						<li title={ _.pluck( @props.data.likes.data, 'full_name').join(', ') }><span className="glyphicon glyphicon-heart"></span> { @props.data.likes.count } likes</li>
						<li><span className="glyphicon glyphicon-map-marker"></span> { @getLocationStr() }</li>
					</ul>
				</div>
			</div>


			{ if @props.data.comments.count then @renderComments() }
		</div>

module.exports = InstagramPhoto