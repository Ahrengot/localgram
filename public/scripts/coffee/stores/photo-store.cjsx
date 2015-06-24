React = require 'react'
Reflux = require 'reflux'
_ = require 'underscore'

PhotoActions = require '../actions/photo-actions'

# Default data to send to components
defaultData =
	loading: false
	results: []

# Create search store
PhotoStore = Reflux.createStore
	init: ->
		@data = defaultData

		PhotoActions.getPhotosByCoords.listen @onQueryPhotos
		PhotoActions.getPhotosByCoords.success.listen @onPhotosSuccess
		PhotoActions.getPhotosByCoords.error.listen @onPhotosError

		PhotoActions.resetPhotos.listen @onResetPhotos

	sortPhotos: (photos) ->
		_.sortBy( photos, (photo) ->
			return parseInt photo.created_time
		).reverse()

	# Login handlers
	onQueryPhotos: ->
		@data.loading = true
		@triggerChange()
	onPhotosSuccess: (res) ->
		newPhotos = _.reject res.data, (photo) =>
			return _.findWhere( @data.results, { id: photo.id } )


		@data.loading = false

		if newPhotos.length
			@data.results = @sortPhotos( @data.results.concat newPhotos )

		@triggerChange()
	onPhotosError: (res) ->
		@data.loading = false
		@triggerChange()

	onResetPhotos: ->
		@data.results = []
		@triggerChange()

	triggerChange: ->
		@trigger @data

module.exports = PhotoStore