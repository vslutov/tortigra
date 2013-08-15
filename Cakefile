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
  


copyFile = (filepath, source, destination, callback) ->
  # dirReg = /[^\/]*\//g
  console.log filepath
  callback()
  ###
  path = destination
  while dir = dirReg.exec(filepath)
    path += dir
    await fs.mkdir path, defer(err)
    throw err if err.code isnt 'EEXIST'

  cbCalled = false
  done = (err) ->
    if not cbCalled
      callback err if typeof callback is 'function'
      cbCalled = true
    
  rd = fs.createReadStream(source + filepath)
  rd.on 'error', (err) =>
    done err
  rd.on 'end', (err) =>
    done()
  wr = fs.createWriteStream(destination + filepath)
  wr.on 'error', (err) =>
    done err
  rd.pipe wr
  ###



less =
  test : (filepath) -> /// ^\./src/(.*)\.less$ ///.exec(filepath)
  run : (ex, callback) ->
          run 'node node_modules/less/bin/lessc ' + ex[0] + ' ./' + ex[1] + 
              '.css', callback


coffee = 
  test : (filepath) -> /// ^\./src/(.*?)([^/]+)\.(lit)?coffee$ ///.exec(filepath)
  run : (ex, callback) -> 
          run 'node node_modules/iced-coffee-script/bin/coffee -mco ./' + ex[1] + 
              ' ' + ex[0], callback


publicFiles = 
  test :  (filepath) -> 
            unless less.test(filepath) or coffee.test(filepath)
              /// ^\./src/public/(.*)$ ///.exec(filepath)
  run : (ex, callback) -> copyFile ex[1], './src/', './', callback


build = (action, files, callback) ->
  for file in files
    ex = action.test(file)
    if ex?
      await action.run ex, defer err
      throw err if err
  callback() if typeof callback is 'function'

task 'build:less', 'Build less files into css', ->
  files ?= dfs('.')
  build less, files, ->
    console.log 'Less files has built'

task 'build:coffee', 'Build coffee files into js', ->
  files ?= dfs('.')
  build coffee, files, ->
    console.log 'Coffee files has built'

task 'build:media', 'Copy media files to build folder', ->
  files ?= dfs('.')
  build publicFiles, files, ->
    console.log 'Media files has been copied'

task 'build:all', 'Build source code into work code', ->
  invoke 'build:less'
  invoke 'build:coffee'
  invoke 'build:public'
