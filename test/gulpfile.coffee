# copyright 2014 Jess Austin <jess.austin@gmail.com>, MIT license

gulp = require 'gulp'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'

gulp.task 'coffee', ->
  gulp.src '../gulp-nav.coffee'
    .pipe coffee()
    .pipe gulp.dest '..'

gulp.task 'test', ['coffee'], ->
  nav  = require '..' # more convenient during development
  42

gulp.task 'default', ['coffee'], ->
  nav  = require '..' # more convenient during development
  gulp.src '**/*.jade'
    .pipe nav()
    .pipe jade pretty: true
    .pipe gulp.dest 'dist'
