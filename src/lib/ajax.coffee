filesystem = require('./filesystem.js')

exports.leaf = (req, res) ->
  filesystem.getDirList req.param('pathname'), (err, files) =>
    res.set 'Content-Type', 'text/plain'
    if not err and files.length > 0
      res.end 'node'
    else
      res.end 'leaf'

exports.initController = (req, res) ->
  app.locals.source = req.param('source')
  app.locals.destination = req.param('destination')
  res.redirect '/'

exports.list = (req, res) ->
  context =
    pathname: /// ([^/]*)/?$ ///.exec(req.param('pathname'))[1] # Name of folder

  filesystem.getDirList req.param('pathname'), (err, files) =>
    context.files = files ? []
    res.render 'list', context

exports.files = (req, res) ->
  pathname = req.param('pathname')
  context =
    root: app.locals.source
    bread: []

  reg = /([^\/]+)\//g
  dirpath = ''
  loop
    a = reg.exec(pathname)
    if a?
      dirpath += a[1] + '/'
      context.bread.push
        name: a[1]
        path: dirpath
    else
      break

  filesystem.readdir pathname, (err, files) =>
    filelist = []
    if files?
      for file in filesystem.fileArrayToFiles(pathname, files)
        try
          if filesystem.statSync( file.path ).isDirectory() 
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

