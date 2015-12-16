## Localgram
Find instagram photos that people post around any given location.

[View demo](http://playground.ahrengot.com/localgram/#/search/40.7127837,-74.0059413@New%20York%2C%20NY%2C%20USA)

![Screenshot from Localgram](https://s3.amazonaws.com/f.cl.ly/items/1B1R1W3i2A180c0f2g2p/localgram.png?v=45ca3695)

### Features & tech
- Flux (Using [Reflux](https://github.com/spoike/refluxjs))
- HTML5 Geolocation
- Reverse address lookup (Using Google Maps API + Typeahead.js)
- Deeplinks (Using [React Router](https://github.com/rackt/react-router))
- CoffeeScript + JSX
- Bootstrap
- Gulp
- Browserify

### To get started
Add your Instagram and Google Maps client.id to index.html. Then run the following commands

1. `$ npm install && bower install`
2. `$ gulp`

This project is based on my [React.js project starter](https://github.com/Ahrengot/project-starter/tree/react/browserify)
