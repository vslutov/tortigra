fs = require('fs')
child_process = require('child_process')
require('sugar')

files = null

dfs = (path) ->
  result = []
  count = 0

  temp = (path) ->
    try
      
      files = fs.readdirSync(path)
      # Now you may goto catch section
      
      result.remove(path)
      for file in files
        result.add(path + '/' + file)

    catch e
      if e.code is 'ENOTDIR'
        ++count
      else
        throw e

  temp(path)
  temp(result[count]) while count < result.length
  
  return result


run = (exe, callback) ->
  await child_process.exec exe, defer error, stdout, stderr
  stderr = stderr.toString()
  console.log(stderr) if stderr isnt ''
  callback(error) if typeof callback is 'function'
  


copyFile = (filepath, destination) -> 0


less =
  test : (filename) -> /// ^./src/(.*)\.less$ ///.exec(filename)
  run : (ex, callback) ->
          run 'node node_modules/less/bin/lessc ' + ex[0] + ' ./' + ex[1] + 
              '.css', callback


coffee = 
  test : (filename) -> /// ^./src/(.*?)([^/]+)\.(lit)?coffee$ ///.exec(filename)
  run : (ex, callback) -> 
          run 'node node_modules/iced-coffee-script/bin/coffee -mco ./' + ex[1] + 
              ' ' + ex[0], callback


css = 
  test : (filename) -> /// ^./src/(.*)\.css$ ///.exec(filename)
  run : (ex, callback) -> 0


build = (action, files, callback) ->

  for file in files
    ex = action.test(file)
    if ex?
      await action.run ex, defer error
      throw error if error

  callback()

build = (action, files, callback) ->
  callback()

task 'build:less', 'Build less files into css', ->
  files ?= dfs('.')
  build less, files, ->
    console.log 'Less files has built'

task 'build:coffee', 'Build coffee files into js', ->
  files ?= dfs('.')
  build coffee, files, ->
    console.log 'Coffee files has built'

task 'build:all', 'Build source code into work code', ->
  invoke 'build:less'
  invoke 'build:coffee'
