fs = require('fs')

exports.getDirList = (dirname, callback) ->
  files = []
  fs.readdir app.get('tortigra source') + dirname, (err, filelist) =>
    if err
      callback err, null
    else
      for file in filelist
        try
          stats = fs.statSync( app.get('tortigra source') + dirname + file )
          if stats.isDirectory()
            files.push dirname + file + '/'
      callback null, files

exports.dirArrayToDirs = (files) ->
  for file in files
    path: file
    name: /// ([^/]*)/?$ ///.exec(file)[1]

exports.fileArrayToFiles = (dirname, files) ->
  for file in files
    path: dirname + file
    name: file

exports.readdir = fs.readdir
exports.statSync = fs.statSync
