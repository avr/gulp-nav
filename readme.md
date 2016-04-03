gulp-nav
========

[![NPM][npmjs-img]][npmjs-url]
[![Build Status][travis-img]][travis-url]
[![Coverage Status][cover-img]][cover-url]
[![Dependency Status][david-img]][david-url]
[![devDependency Status][david-dep-img]][david-dep-url]

A [gulp](http://gulpjs.com/) plugin to help build navigation or breadcrumb
elements implicitly from our file structure. The goal is to be useful with e.g.
[Bootstrap .nav classes](http://getbootstrap.com/components/#nav) and your
favorite templating system. (If you need templates, try
[Jade](http://jade-lang.com/).) **gulp-nav** can handle
[Vinyl file objects][vfo] with [stream][stream] `contents` and with
[buffer][buffer] `contents`.

Imagine we have some source files in a directory hierarchy:
```
  .
  ├── greek
  │   ├── alpha.jade
  │   ├── beta.jade
  │   ├── delta.jade
  │   └── gamma.jade
  ├── index.jade
  ├── latin
  │   ├── b.jade
  │   ├── c.jade
  │   ├── index.jade
  │   └── letter-a.jade
  ├── one.jade
  ├── three.jade
  └── two.jade
```
We know how to [`.pipe`][pipe] these through appropriate plugins and
transforms, leaving us with a bunch of output pages in a similar directory
hierarchy. What about links between those pages, however? We don't want to
hardcode that stuff! While each file is piped through, an object stored as a
property of the [Vinyl file object][vfo], which stored object knows where other
files are located and what they are called, could be really useful to template
plugins. With that information, a template could be written to build navbars,
breadcrumbs, or whatever we want on our generated page.

What would this look like? If we had this in our gulpfile...

```javascript
var gulp = require('gulp'),
    data = require('gulp-data'),
    matter = require('jade-var-matter'),
    nav = require('gulp-nav'),
    jade = require('gulp-jade');

gulp.task('default', function() {
    return gulp.src('src/**/*.jade')
        // gulp-nav will use title or order properties if they are included
        // in file.data, but that is completely optional
        .pipe(data(function(file) {
            return matter(String(file.contents));
        }))
        .pipe(nav())
        .pipe(jade())
        .pipe(gulp.dest('dist'));
});
```
...and our template file had something like this...

```jade
  nav
    ul.nav.nav-tabs
      for sibling in nav.siblings
        li
          a(href=sibling.href)= sibling.title
```
...that would be enough to generate easy, maintainable navbars! [This slightly
more elaborate template file](test/index.jade) generates the nav for [the demo
site](http://jessaustin.github.io/gulp-nav/).

The `nav` object referenced above has the following properties:

| property | description                                                      |
| :------: | ---------------------------------------------------------------- |
| title    | Identifier for this resource.                                    |
| href     | Relative link to this resource. `null` for a directory without an index. |
| active   | Is this resource the current one? `true` or `false`.             |
| parent   | `nav` object representing this resource's parent. `null` for the root resource. |
| children | Array of `nav` objects representing this resource's children. Empty when this resource isn't a directory. |
| siblings | Array of `nav` objects representing this resource's parent's children. Includes this resource. |
| root     | `nav` object representing the ancestor of all streamed resources. |

If you want `children` and `siblings` to be in a particular order, just have an
`order` property defined on each [file object][vfo]. `order` should be a
number, small for the "first" resource and large for the "last" resource in the
directory.

There are a bunch of options we can pass into the plugin (in an object), which
are currently undocumented because they have sensible defaults and they might
change. If you want to know all about the options then [read the
source](gulp-nav.coffee#L38-L40).

One current default is to expose the nav data at both the `nav` and `data.nav`
(the latter for use with the new ["data
API"](https://github.com/colynb/gulp-data#note-to-gulp-plugin-authors))
properties of the [file object][vfo], although either or both of these may be
overridden via the `targets` option.

## Thanks!

**gulp-nav** is by Jess Austin and is distributed under the terms of the [MIT
license](http://opensource.org/licenses/MIT). Any and all potential
contributions of issues and pull requests are welcome!

Special thanks to **Arlando Battle** for windows compatibility!

[travis-url]: https://travis-ci.org/jessaustin/gulp-nav "Travis"
[travis-img]: https://travis-ci.org/jessaustin/gulp-nav.svg?branch=master
[cover-url]: https://coveralls.io/r/jessaustin/gulp-nav?branch=master "Coveralls"
[cover-img]: https://coveralls.io/repos/jessaustin/gulp-nav/badge.svg?branch=master
[david-url]: https://david-dm.org/jessaustin/gulp-nav "David"
[david-img]: https://david-dm.org/jessaustin/gulp-nav.svg
[david-dep-url]: https://david-dm.org/jessaustin/gulp-nav#info=devDependencies "David for dev"
[david-dep-img]: https://david-dm.org/jessaustin/gulp-nav/dev-status.svg
[npmjs-url]: https://www.npmjs.org/package/gulp-nav "npm Registry"
[npmjs-img]: https://badge.fury.io/js/gulp-nav.svg
[stream]: http://nodejs.org/api/stream.html "Node Stream"
[buffer]: http://nodejs.org/api/buffer.html "Node Buffer"
[pipe]: http://nodejs.org/api/stream.html#stream_readable_pipe_destination_options "stream.Readable.pipe()"
[vfo]: https://github.com/wearefractal/vinyl#file "Vinyl File Object"
