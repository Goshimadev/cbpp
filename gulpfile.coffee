path = require 'path'
replaceExt = require "replace-ext"
gulp = require 'gulp'
fs = require "fs"

makeHTML = require "make-document-html"

browserify = require 'gulp-browserify'
expect = require 'gulp-expect-file'
coffee = require 'gulp-coffee'
pug = require 'gulp-pug'
beautify = require "gulp-beautify"
header = require 'gulp-header'
footer = require 'gulp-footer'
stylus = require 'gulp-stylus'
cson = require 'gulp-cson'
util = require 'gulp-util'
zip = require 'gulp-zip'

gulp.task 'default', ['compile-js','compile-css','build-manifest','copy-icons','make-html'], ->
  manifest = require("./build/manifest.json")
  manifest.version = require("./package.json").version
  fs.writeFileSync "./build/manifest.json", JSON.stringify(manifest, null, 2)

gulp.task 'zip', ['default'], ->
  gulp
    .src('build/**/*')
    .pipe(zip('build.zip'))
    .pipe(gulp.dest(''))

gulp.task "make-html", ->
  for name in ["options","popup"]
    fs.writeFileSync "build/#{name}.html", makeHTML
      title: "CB++ #{name}"
      cssPath: "css/#{name}.css"
      jsPath: "js/#{name}.js"

gulp.task 'compile-js', ['transpile-coffee','transpile-pug'], ->
  for filename in ['contentscript', 'eventpage', 'options', 'popup']
    filepath = "compiled/js/#{filename}.js"
    gulp
      .src(filepath)
      .pipe(expect(filepath))
      .pipe(browserify
        insertGlobals: false
        debug: !util.env.production)
      .pipe gulp.dest('build/js')

gulp.task 'transpile-coffee',  ->
  gulp
    .src("./src/**/*.coffee")
    .pipe(coffee())
    .pipe gulp.dest('compiled')

gulp.task 'compile-css', ->
  for name in ['chaturbate','options','popup']
    gulp
      .src("./src/css/#{name}.styl")
      .pipe(stylus())
      .pipe gulp.dest('build/css')

gulp.task 'build-manifest', ->
  gulp.src './src/manifest.cson'
    .pipe cson()
    .pipe gulp.dest 'build'

gulp.task 'copy-icons', ->
  gulp.src(['icons/**/*']).pipe(gulp.dest('build/icons'));

gulp.task 'transpile-pug', ->
  gulp
    .src('./src/**/*.pug')
    .pipe(pug
      client: true
      inlineRuntimeFunctions: false
      debug: false
      compileDebug: false)
    .pipe(beautify({indent_size: 2}))
    .pipe(header("var pug = require('pug-runtime');\n\nmodule.exports = "))
    .pipe gulp.dest('compiled')

gulp.task "watch", ->
  watcher = gulp.watch 'src/**/*.*', [ 'default' ]
  watcher.on "change", (event) ->
    return unless event.type is "deleted"
    relativeSrcPath = path.relative(path.resolve('src'), event.path)
    destPath = replaceExt(path.resolve('compiled',relativeSrcPath), ".js")
    fs.unlinkSync destPath
