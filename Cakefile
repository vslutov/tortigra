fs = require('fs')
child_process = require('child_process')
require('sugar')


runOnceCalled = false
runOnce = (options, callback) ->
  await dfs '.', defer(module.files)
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
  


copyFile = (filepath, source, destination, callback) ->
  dirReg = /[^\/]*\//g

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
      await action.run ex, defer(error)
      throw error if error

  callback()

async task 'build:less', 'Build less files into css', (options, callback) ->
  await build less, module.files, defer()
  console.log 'Less files has been built'
  callback()

async task 'build:coffee',  'Build coffee files into js', (options, callback) ->
  await build coffee, module.files, defer()
  console.log 'Coffee files has been built'
  callback()

async task 'build:public', 'Copy public files to build folder', (options, callback) ->
  await build publicFiles, module.files, defer()
  console.log 'Public files has been copied'
  callback()

task 'build:all',  'Build source code into work code', (options, callback) ->
  await invoke 'build:less', defer()
  await invoke 'build:coffee', defer()
  await invoke 'build:public', defer()
  console.log 'All files has been built'



