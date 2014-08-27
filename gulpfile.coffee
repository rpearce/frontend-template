gulp = require 'gulp'
compass = require 'gulp-compass'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
minifyCSS = require 'gulp-minify-css'
browserify = require 'browserify'
source = require 'vinyl-source-stream'

gulp.task 'compass', ->
  gulp.src('./src/sass/*.sass')
    .pipe compass(config_file: './compass.rb', css: 'public', sass: 'src/sass')
    .pipe minifyCSS()
    .pipe gulp.dest('./public')

gulp.task 'scripts', ->
  bundleStream = browserify(entries: ['./src/coffee/app.coffee'], extensions: ['.coffee']).bundle()
  bundleStream
    .pipe source('app.js')
    .pipe streamify(uglify())
    .pipe gulp.dest('./public')

gulp.task 'watch', ['compass', 'scripts'], ->
  gulp.watch('src/sass/**/*.sass', ['compass'])
  gulp.watch('src/coffee/**/*.coffee', ['scripts'])

gulp.task 'default', ['watch', 'scripts', 'compass']
