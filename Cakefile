fs = require('fs')
spawn = require('child_process').spawn
require('sugar')

dfs = (callback) ->
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

  temp('.')
  temp(result[count]) while count < result.length
  
  callback(result)

dfs(console.log)
