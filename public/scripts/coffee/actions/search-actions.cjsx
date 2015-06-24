Reflux = require 'reflux'

_ = require 'underscore'
$ = require 'jquery'

SearchActions = Reflux.createActions
	getLocation:
		children: ['success', 'error']

SearchActions.getLocation.listen (query) ->
	$.ajax
		url: 'https://maps.googleapis.com/maps/api/geocode/json'
		dataType: 'json'
		data:
			address: encodeURIComponent query
			client_id: window.gmapsClientId
		success: @success
		error: @error

module.exports = SearchActions
