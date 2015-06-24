Reflux = require 'reflux'
_ = require 'underscore'

SearchActions = require '../actions/search-actions'

# Default data to send to components
defaultData =
	loading: false
	results: []

# Create search store
SearchLocationStore = Reflux.createStore
	listenables: [SearchActions]
	init: ->
		@data = defaultData

	# Login handlers
	onGetLocation: ->
		@data.loading = true
		@data.results = []
		@triggerChange()
	onGetLocationSuccess: (res) ->
		@data.loading = false
		@data.results = res.results
		@triggerChange()
	onGetLocationError: (res) ->
		@data.loading = false
		@triggerChange()

	triggerChange: ->
		@trigger @data

module.exports = SearchLocationStore