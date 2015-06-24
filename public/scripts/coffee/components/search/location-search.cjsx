React = require 'react'
Router = require 'react-router'
_ = require 'underscore'

UserActions = require '../../actions/user-actions'
UserStore = require '../../stores/user-store'

LocationSearch = React.createClass
	mixins: [Router.Navigation]
	getInitialState: ->
		location: {}
		address: ''
		loading: false
	onStoreUpdate: ->
		@setState UserStore.data
	componentWillMount: ->
		@unsubscribe = UserStore.listen( @onStoreUpdate )
	componentWillUnmount: ->
		@unsubscribe()
	componentDidUpdate: (prevProps, prevState) ->
		if @state.location.latitude
			if !prevState.address and @state.address
				@transitionTo "search",
					ll: _.values(_.pick(@state.location, "latitude", "longitude")).join(",")
					address: encodeURIComponent @state.address
	onClick: ->
		UserActions.getLocation()
	getBtnText: ->
		if @state.loading
			"Getting location ..."
		else
			"Get location"
	render: ->
		<button className="btn btn-default" onClick={ @onClick }><span className="glyphicon glyphicon-map-marker"></span> { @getBtnText() }</button>

module.exports = LocationSearch