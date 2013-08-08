fs = require('fs')
spawn = require('child_process').spawn

dfs = (callback) ->
  count = 0
  result = {}
  temp = (pathname) ->
    ++count
    fs.stat pathname, (error, fileinfo) =>
      result[pathname] = fileinfo.mtime.valueOf()
      fs.readdir pathname, (error, filelist) =>
        --count
        if not error? then for file in filelist then temp(pathname + '/' + file)
        if count is 0 then callback(result)
  temp('.')

count = 0
maybe = () ->
  --count
  if count is 0 
    child = spawn('node', ['lib/index.js'])
    child.stdout.on 'data', (data) =>
      process.stdout.write data
    child.stderr.on 'data', (data) =>
      process.stdout.write data

dfs (filelist) =>
  for file, mtime of filelist
    ex = /// ^./src/(.*)\.less$ ///.exec(file)
    if ex?
      ++count
      spawn('node', ['node_modules/less/bin/lessc', file, './' + ex[1] + '.css']).on 'exit', maybe
      
    ex = /// ^./src/(.*?)([^/]+)\.coffee$ ///.exec(file)
    if ex?
      ++count
      spawn('node', ['node_modules/coffee-script/bin/coffee', '-co', './' + ex[1], file]).on 'exit', maybe
  ++count
  maybe() 
