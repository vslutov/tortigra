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

mkDir = (parent, pathname, callback) ->
  getDir = new RegExp(parent+'([^/]*)/')
  dir = getDir.exec(pathname)
  if dir?
    dir = dir[1]
    fs.mkdir app.locals.destination+parent+dir, (err) =>
      mkDir parent+dir+'/', pathname, callback
  else
    callback()

exports.copyFile = (pathname, callback) ->
  mkDir '', pathname, () =>
    cbCalled = false
    done = (err) ->
      if not cbCalled
        callback err
        cbCalled = true
    
    rd = fs.createReadStream(app.locals.source + pathname)
    rd.on 'error', (err) =>
      done err
    rd.on 'end', (err) =>
      done()

    wr = fs.createWriteStream(app.locals.destination + pathname)
    wr.on 'error', (err) =>
      done err

    rd.pipe wr

exports.copyFolder = (pathname, callback) ->
  mkDir '', pathname, () =>
    callback()


exports.isFolder = (pathname) ->
  pathname.endsWith('/') or pathname is ''

exports.isParent = (parent, pathname) ->
  pathname.startsWith(parent) and exports.isFolder(parent)
