var gulp = require( 'gulp' );
var _ = require( 'underscore' );

// Load plugins
var $ = require( 'gulp-load-plugins' )();

// Helpers
var paths = {
	sass: './public/styles/sass',
	css: './public/styles/css',
	coffee: './public/scripts/coffee',
	js: './public/scripts/js',
	app: './public'
}

/**
 * Compile sass and add vendor prefixes
 */
gulp.task('sass', function() {
	return gulp.src( paths.sass + '/**/*.scss' )
		.pipe( $.sass() )
		.pipe( $.autoprefixer( 'last 2 versions' ) )
		.pipe( gulp.dest( paths.css ) )
		.pipe( $.size({ title: "Compiled CSS", gzip: true }) );
});

gulp.task('browserify', function(){
	return gulp.src( paths.coffee + "/app-bootstrap.cjsx", {read: false} )
		.pipe(
			$.browserify({
				transform: ['coffee-reactify'],
				extensions: ['.cjsx', '.coffee']
			})
		).on('error', function(err){
			$.util.beep();
			$.util.log($.util.colors.red('Error'), err.message + "\nStack:\n\n", err.stack);
			this.emit('end');
		})
		.pipe($.rename('combined.js'))
		.pipe(gulp.dest( paths.js ))
	    .pipe( $.size({ title: "Compiled JavaScript", gzip: true }) );
});

gulp.task('uglify', ['browserify'], function() {
	return gulp.src( paths.js + "/combined.js" )
		.pipe( $.uglify() )
		.pipe( $.rename( 'combined.min.js' ) )
		.pipe( gulp.dest( paths.js ) );
});

/**
 * Tiny HTTP server with connect
 */
gulp.task('connect', function () {
	var connect = require('connect');
	var app = connect()
		.use( require('connect-livereload')({ port: 35729 }) )
		.use( connect.static( paths.app ) )
		.use( connect.directory( paths.app ) );

	require('http').createServer(app).listen( 9000 ).on('listening', function () {
		console.log('Started connect web server on http://localhost:9000');
	});
});


gulp.task('host', ['sass', 'browserify', 'connect'], function() {

});

/**
 * Compile assets and open url in browser
 */
gulp.task('serve', ['host'], function () {
	require( 'opn' )( 'http://localhost:9000' );
});

/**
 * Set up file watching and live browser reloading
 */
gulp.task('watch', ['host'], function() {
	var server = $.livereload();

	// Watch for changes to compiled files
	gulp.watch([
		paths.app + '/*.html',
		paths.css + '/**/*.css',
		paths.js + '/**/*.js',
	]).on('change', function(file) {
		server.changed(file.path);
	});

	gulp.watch( paths.sass + '/**/*.scss', ['sass'] );
	gulp.watch( paths.coffee + '/**/*.cjsx', ['browserify'] );
});

/**
 * Default gulp task
 */
gulp.task( 'default', ['watch'] );