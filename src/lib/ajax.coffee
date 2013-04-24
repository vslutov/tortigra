filesystem = require('./filesystem.js')

exports.leaf = (req, res) ->
  filesystem.getDirList req.param('dirname'), (err, files) =>
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

  filesystem.getDirList dirname, (err, files) =>
    if files?
      context.files = filesystem.dirArrayToDirs(files)
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

  filesystem.readdir app.get('tortigra source') + dirname, (err, files) =>
    filelist = []
    if files?
      for file in filesystem.fileArrayToFiles(dirname, files)
        try
          if filesystem.statSync( app.get('tortigra source') + file.path ).isDirectory() 
            file.icon = 'folder'
            file.path += '/'
          else if /// (?:\.) (?: 
            jpe?g | png | gif | 
            bmp | tiff | raw | 
            ico | svg | wbmp
           ) $ ///.test(file.path)
            file.icon = 'image'
          else if /// (?:\.) (?: 
            mpe?g | mp4  | avi | 
            webm | ogg | flv | 
            wmv | mkv
           ) $ ///.test(file.path) 
            file.icon = 'video'         
          else if /// (?:\.) (?: 
            exe | bat | sh |
            py | php | perl
           ) $ ///.test(file.path) 
            file.icon = 'app' 
          else 
            file.icon = 'file'
          filelist.push file
    context.files = filelist
    res.render 'files', context

