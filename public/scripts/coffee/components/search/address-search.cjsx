React = require 'react'
Router = require 'react-router'
$ = require 'jquery'
_ = require 'underscore'

typeahead = require 'typeahead.js/dist/typeahead.jquery'
Bloodhound = require 'typeahead.js/dist/bloodhound'

AddressSearch = React.createClass
	mixins: [Router.Navigation, Router.State]
	getDefaultProps: ->
		query: ''
		placeholder: 'ie. Manhattan, USA'
		addOnText: 'Search'
	getInitialState: ->
		query: @props.query or ""
	componentWillMount: ->
		_.bindAll( this, "onSelectOption" )
		@onRequestResults = _.debounce( @onRequestResults, 350 )
	componentDidMount: ->
		$input = $( @refs.searchInput.getDOMNode() )
		$input.typeahead( { highlight: true, autoselect: true }, @getTypeaheadOpts() )
		$input.on( "typeahead:selected", @onSelectOption )
	componentDidUpdate: (prevProps, prevState) ->
		if prevProps.query isnt @props.query
			@setState { query: @props.query }
	getTypeaheadOpts: ->
		name: "locations",
		displayKey: "formatted_address",
		source: new Bloodhound
			datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
			queryTokenizer: Bloodhound.tokenizers.whitespace
			remote:
				url: "https://maps.googleapis.com/maps/api/geocode/json?client_id=#{gmapsClientId}&address=%QUERY"
				wildcard: '%QUERY'
				transform: (response) -> response.results
		templates:
			empty: "<p class='tt-no-results'>No results</p>"
	onSelectOption: (e, option) ->
		@setState { query: option.formatted_address }
		@transitionTo "search",
			ll: _.values(option.geometry.location).join(',')
			address: encodeURIComponent option.formatted_address
	onChangeQuery: ->
		@setState
			query: @refs.searchInput.getDOMNode().value
	onSubmit: (e) ->
		e.preventDefault()
		if @state.query
			@transitionTo 'search', { query: encodeURIComponent @state.query }
		else
			@transitionTo 'app'
	render: ->
		<div className="typeahead">
			<input type="search" ref="searchInput" className="form-control" placeholder={ @props.placeholder } value={ @state.query } onChange={ @onChangeQuery } />
		</div>

module.exports = AddressSearch