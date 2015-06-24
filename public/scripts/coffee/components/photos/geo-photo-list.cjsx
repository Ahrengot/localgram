React = require 'react'
_ = require 'underscore'

PhotoStore = require '../../stores/photo-store'
PhotoActions = require '../../actions/photo-actions'

InstagramPhoto = require './instagram-photo'

GeoPhotoList = React.createClass
	getInitialState: ->
		loading: false
		results: []
	onStoreUpdate: ->
		@setState _.pick( PhotoStore.data, 'loading', 'results' )
	componentWillMount: ->
		@unsubscribe = PhotoStore.listen( @onStoreUpdate )
		if @props.coords
			PhotoActions.getPhotosByCoords @props.coords
	componentWillUnmount: ->
		@unsubscribe()
	componentDidUpdate: (prevProps, prevState) ->
		if prevProps.coords isnt @props.coords
			PhotoActions.getPhotosByCoords @props.coords
	loadNextSet: ->
		if not @state.loading
			PhotoActions.getPhotosByCoords( @props.coords, _.last(@state.results).created_time )
	renderPhoto: (photo) ->
		<InstagramPhoto key={ photo.id } images={ photo.images } user={ photo.user } userCoords={ @props.coords } location={ photo.location } data={ _.pick(photo, 'caption', 'likes', 'link', 'tags', 'created_time', 'comments') } />
	renderLoadMoreBtn: ->
		return if @state.results.length is 0
		<button className="btn btn-primary center-block" style={{marginTop: 18}} onClick={ @loadNextSet }>{ if @state.loading then "Loading ..." else "Load more" }</button>
	render: ->
		if @state.loading and @state.results.length is 0
			<p className="text-center">Getting photos...</p>
		else
			<div className="photo-list">
				{ _.map( @state.results, @renderPhoto ) }
				{ @renderLoadMoreBtn() }
			</div>

module.exports = GeoPhotoList