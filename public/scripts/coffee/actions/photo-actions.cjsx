$ = require 'jquery'
Reflux = require 'reflux'


PhotoActions = Reflux.createActions
	getPhotosByCoords:
		children: ['success', 'error']
	resetPhotos:
		children: ['success', 'error']
	refresh:
		children: ['success', 'error']

# Get photos
PhotoActions.getPhotosByCoords.listen (coords, before) ->
	params =
		lat: coords.latitude
		lng: coords.longitude
		distance: 5000
		client_id: igClientId

	if before
		params.max_timestamp = before

	$.ajax
		url: 'https://api.instagram.com/v1/media/search'
		dataType: 'jsonp'
		data: params
		success: PhotoActions.getPhotosByCoords.success
		error: PhotoActions.getPhotosByCoords.error

PhotoActions.refresh.listen ->
	# PhotoActions.resetPhotos()
	PhotoActions.getPhotosByCoords()


module.exports = PhotoActions
