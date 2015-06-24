Reflux = require 'reflux'
$ = require 'jquery'
_ = require 'underscore'

UserActions = Reflux.createActions
	getLocation:
		children: ['success', 'error']
	reverseLookup:
		children: ['success', 'error']
	setLocation:
		children: ['success', 'error']

UserActions.getLocation.listen ->
	navigator.geolocation.getCurrentPosition (pos) =>
		@success pos
		UserActions.reverseLookup pos


UserActions.reverseLookup.listen (pos) ->
	$.ajax
		url: "https://maps.googleapis.com/maps/api/geocode/json"
		dataType: "json"
		data:
			latlng: _.values(_.pick(pos.coords, "latitude", "longitude")).join(",")
			client_id: gmapsClientId
		success: @success
		error: @error


module.exports = UserActions
