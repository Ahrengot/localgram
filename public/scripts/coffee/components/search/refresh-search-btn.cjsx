React = require 'react'
Router = require 'react-router'
_ = require 'underscore'

PhotoActions = require '../../actions/photo-actions'
PhotoStore = require '../../stores/photo-store'

RefreshSearchBtn = React.createClass
	mixins: [Router.Navigation]
	getInitialState: ->
		loading: false
	onStoreUpdate: ->
		@setState _.pick( PhotoStore.data, "loading" )
	componentWillMount: ->
		@unsubscribe = PhotoStore.listen( @onStoreUpdate )
	componentWillUnmount: ->
		@unsubscribe()
	refresh: ->
		PhotoActions.getPhotosByCoords @props.coords
	getBtnText: ->
		if @state.loading
			"Refreshing ..."
		else
			"Refresh"
	render: ->
		<button className="btn btn-default" onClick={ @refresh }><span className="glyphicon glyphicon-repeat"></span> { @getBtnText() }</button>

module.exports = RefreshSearchBtn