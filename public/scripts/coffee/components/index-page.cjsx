React = require 'react'
_ = require 'underscore'

# Actions and stores
UserStore = require '../stores/user-store'

# Components
GeoPhotos = require './photos/geo-photo-list'
AddressSearch = require './search/address-search'
LocationSearchBtn = require './search/location-search'
RefreshResultsBtn = require './search/refresh-search-btn'

IndexPage = React.createClass
	getInitialState: ->
		location: {}
	onStoreUpdate: ->
		@setState _.pick( UserStore.data, 'location' )
	componentWillMount: ->
		@unsubscribe = UserStore.listen( @onStoreUpdate )
	componentWillUnmount: ->
		@unsubscribe()
	getAddressFromUrl: ->
		if @props.params?.address
			decodeURIComponent @props.params.address
		else
			null
	renderRefreshBtn: ->
		<div className="btn-group">
			<RefreshResultsBtn coords={ @state.location } />
		</div>
	render: ->
		<div className="instagram-photos">
			<AddressSearch query={ @getAddressFromUrl() } addOnText="Location" />
			<div className="btn-group btn-group-justified">
				<div className="btn-group">
					<LocationSearchBtn />
				</div>
				{ if @state.location.latitude then @renderRefreshBtn() }
			</div>
			<GeoPhotos coords={ @state.location } />
		</div>

module.exports = IndexPage