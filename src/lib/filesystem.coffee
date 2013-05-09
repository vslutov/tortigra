fs = require('fs')

exports.getDirList = (pathname, callback) ->
  fs.readdir app.locals.source + pathname, (err, filelist) =>
    if err
      callback err, null
    else
      files = []
      for file in filelist
        try
          stats = fs.statSync( app.locals.source + pathname + file )
          if stats.isDirectory()
            files.push
              path: pathname + file + '/'
              name: file
      callback null, files

exports.fileArrayToFiles = (pathname, files) ->
  for file in files
    path: pathname + file
    name: file

exports.readdir = (pathname, callback) ->
  fs.readdir app.locals.source + pathname, (err, result) =>
    callback err, result

exports.statSync = (pathname) ->
  fs.statSync app.locals.source + pathname
