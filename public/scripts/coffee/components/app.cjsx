React = require 'react'
Router = require 'react-router'
Footer = require './footer'

RouteHandler = Router.RouteHandler

App = React.createClass
	render: ->
		<div>
			<RouteHandler />
			<Footer />
		</div>

module.exports = App