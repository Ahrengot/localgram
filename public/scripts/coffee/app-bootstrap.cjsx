React = require 'react'
Router = require 'react-router'

App = require './components/app'
IndexPage = require './components/index-page'

UserActions = require './actions/user-actions'
PhotoActions = require './actions/photo-actions'

{ DefaultRoute, Route } = Router

routes =
	<Route name="app" path="/" handler={ App }>
		<Route name="search" path="/search/:ll@:address" handler={ IndexPage } />
		<DefaultRoute handler={ IndexPage } />
	</Route>

# Start listening for route changes
Router.run routes, (Handler, state) ->
	React.render( <Handler />, document.getElementById 'app' )

	# If route changes that means new location so always reset photos
	PhotoActions.resetPhotos()

	if state.path[0...8] is "/search/"
		ll = state.params.ll.split(",")
		UserActions.setLocation { latitude: ll[0], longitude: ll[1] }
