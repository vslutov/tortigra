fs = require('fs')
child_process = require('child_process')
require('sugar')

dfs = (path, callback) ->
  console.log 'dfs start'
  result = [path]
  count = 0

  while count < result.length
    await fs.readdir result[count], defer err, files
    if err 
      ++count
    else
      for file in files
        result.add(result[count] + '/' + file)
      result.splice(count, 1)
  
  console.log 'dfs end'
  callback result


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

task 'build:less', 'Build less files into css', () ->
  #await build less, files
  console.log module.files.length
  console.log 'Less files has built'

task 'build:coffee',  'Build coffee files into js', () ->
  #await build coffee, files
  console.log module.files.length
  console.log 'Coffee files has built'
  callback()

task 'build:all',  'Build source code into work code', (callback) ->
  await dfs '.', defer module.files unless module.files
  invoke 'build:less'
  invoke 'build:coffee'
