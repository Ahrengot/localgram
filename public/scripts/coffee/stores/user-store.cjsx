React = require 'react'
Reflux = require 'reflux'
_ = require 'underscore'

UserActions = require '../actions/user-actions'

# Default data to send to components
defaultData =
	loading: false
	address: ''
	location: {}

# Create search store
UserStore = Reflux.createStore
	listenables: [UserActions]
	init: ->
		@data = _.clone(defaultData)

	parseCoords: (coords) ->
		latitude: parseFloat coords.latitude
		longitude: parseFloat coords.longitude

	# Async location fetching (HTML5 geolocation)
	onGetLocation: ->
		@data.loading = true
		@data.address = ''
		@data.location = {}
		@triggerChange()
	onGetLocationError: ->
		@data.loading = false
		@triggerChange()
	onGetLocationSuccess: (pos) ->
		@data.location = @parseCoords pos.coords
		@data.loading = false
		@triggerChange()
	onReverseLookup: (pos) ->
		@data.address = ''
		@data.loading = true
		@data.location = @parseCoords pos.coords
		@triggerChange()
	onReverseLookupSuccess: (res) ->
		@data.loading = false
		@data.address = _.first(res.results).formatted_address
		@triggerChange()

	# Sync location fetching (from URL)
	onSetLocation: (pos) ->
		@onGetLocationSuccess { coords: pos }

	triggerChange: ->
		@trigger @data

module.exports = UserStore