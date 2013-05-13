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

toDirMaybe = (pathname) ->
  if fs.statSync(app.locals.source + pathname).isDirectory()
    pathname + '/'
  else
    pathname

exports.fileArrayToFiles = (pathname, files) ->
  for file in files
    try
      path: toDirMaybe(pathname + file)
      name: file

exports.readFolder = (pathname, callback) ->
  fs.readdir app.locals.source + pathname, (err, files) =>
    result = []
    if files?
      for file in files
        result.push toDirMaybe(pathname + file)
    callback err, result

exports.readdir = (pathname, callback) ->
  fs.readdir app.locals.source + pathname, (err, files) =>
    callback err, files

exports.isFolder = (pathname) ->
  pathname.endsWith('/') or pathname is ''
