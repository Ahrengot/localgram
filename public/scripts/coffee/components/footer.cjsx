React = require 'react'
_ = require 'underscore'

Footer = React.createClass
	render: ->
		<footer className="container-fluid text-center">
			<small>Built using <a href="https://github.com/Ahrengot/project-starter/tree/react/browserify">React Project Starter</a></small>
		</footer>

module.exports = Footer