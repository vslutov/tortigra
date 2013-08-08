fs = require('fs')
spawn = require('child_process').spawn
require('sugar')

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

run = (exe, args, callback) ->
  proc = spawn(exe, args)
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.on        'exit', (status) ->
    process.exit(1) if status != 0
    cb() if typeof cb is 'function'

less =
  test : (filename) -> /// ^./src/(.*)\.less$ ///.exec(filename)
  run : (ex, callback) ->
          run 'node', 
              ['node_modules/less/bin/lessc', ex[0], './' + ex[1] + '.css'], 
              callback

coffee = 
  test : (filename) -> /// ^./src/(.*?)([^/]+)\.coffee$ ///.exec(filename)
  run : (ex, callback) -> spawn('node', ['node_modules/coffee-script/bin/coffee'], 
                                '-co', './' + ex[1], ex[0]).on 'exit', callback


build = (actions, files, callback) ->
  count = 0
  complete = () ->
    --count
    if count is 0
      callback()

  for file in files
    for action in actions
      ex = action.test(file)
      if ex?
        ++count
        action.run(ex, complete)
      

task 'build:less', 'Build less files into css', (options) ->
  files = dfs('.')
  build [less], files, () ->
    console.log 'All good!'
