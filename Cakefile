fs = require('fs')
child_process = require('child_process')
require('sugar')

runOnceCalled = false
runOnce = (options, callback) ->
  await dfs './', defer(module.files)
  callback()

old = 
  invoke: global.invoke
options = null

invoke = (name, callback) ->

  unless options
    task '__options', 'Give back an options', (options) -> options
    options = old.invoke '__options'

  unless runOnceCalled
    await runOnce options, defer()
    runOnceCalled = true

  cbCalled = false
  cb = ->
    unless cbCalled
      callback() if typeof callback is 'function'
      cbCalled = true

  if async.tasks[name]
    async.tasks[name].action options, cb
  else
    old.invoke name
  
  cb()

global.invoke = invoke

async = (task) ->
  async.tasks[task.name] = task
async.tasks = []


dfs = (path, callback) ->
  result = [path]
  count = 0

  while count < result.length
    await fs.readdir result[count], defer(err, files)
    if err 
      ++count
    else
      for file in files
        result.add(result[count] + '/' + file)
      result.splice(count, 1)
  
  callback result


run = (exe, callback) ->
  await child_process.exec exe, defer(error, stdout, stderr)
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
      await action.run ex, defer(error)
      throw error if error

  callback()


async task 'build:less', 'Build less files into css', (options, callback) ->
  await build less, module.files, defer()
  console.log 'Less files has built'
  callback()

async task 'build:coffee',  'Build coffee files into js', (options, callback) ->
  await build coffee, module.files, defer()
  console.log 'Coffee files has built'
  callback()

task 'build:all',  'Build source code into work code', (options, callback) ->
  await invoke 'build:less', defer()
  await invoke 'build:coffee', defer()
