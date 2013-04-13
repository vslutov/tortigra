fs = require('fs')
require('sugar')

getDirList = (dirname, callback) ->
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

dirArrayToDirs = (files) ->
  for file in files
    path: file
    name: /// ([^/]*)/?$ ///.exec(file)[1]

fileArrayToFiles = (dirname, files) ->
  for file in files
    path: dirname + file
    name: file

exports.leaf = (req, res) ->
  getDirList req.param('dirname'), (err, files) =>
    res.set 'Content-Type', 'text/plain'
    if not err and files.length > 0
      res.end 'node'
    else
      res.end 'leaf'

exports.initController = (req, res) ->
  app.set 'tortigra source', req.param('source')
  app.set 'tortigra destination', req.param('destination')
  res.redirect '/'

exports.list = (req, res) ->
  dirname = req.param('dirname')
  context =
    dirname: /// ([^/]*)/?$ ///.exec(dirname)[1]
    files: []
  if context.dirname is '' then context.dirname = app.get('tortigra source')

  getDirList dirname, (err, files) =>
    if files?
      context.files = dirArrayToDirs(files)
    res.render 'list', context

exports.files = (req, res) ->
  dirname = req.param('dirname')
  context =
    root: app.get('tortigra source')
    bread: []

  reg = /([^\/]+)\//g
  dirpath = ''
  loop
    a = reg.exec(dirname)
    if a?
      dirpath += a[1] + '/'
      context.bread.push
        name: a[1]
        path: dirpath
    else
      break

  fs.readdir app.get('tortigra source') + dirname, (err, files) =>
    filelist = []
    if files?
      for file in fileArrayToFiles(dirname, files)
        try
          if fs.statSync( app.get('tortigra source') + file.path ).isDirectory() 
            file.type = 'folder'
            file.path += '/'
          else if /// (?:\.) (?: 
            jpe?g | png | gif | 
            bmp | tiff | raw | 
            ico | svg | wbmp
           ) $ ///.test(file.path)
            file.type = 'image'
          else if /// (?:\.) (?: 
            mpe?g | mp4  | avi | 
            webm | ogg | flv | 
            wmv | mkv
           ) $ ///.test(file.path) 
            file.type = 'video'         
          else if /// (?:\.) (?: 
            exe | bat | sh |
            py | php | perl
           ) $ ///.test(file.path) 
            file.type = 'application' 
          else 
            file.type = 'file'
          filelist.push file
    context.files = filelist
    res.render 'files', context
