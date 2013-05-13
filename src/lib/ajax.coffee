filesystem = require('./filesystem.js')
require('sugar')

isChecked = (pathname) ->
  app.locals.task.some (elem) -> pathname.startsWith(elem) and filesystem.isFolder(elem) or elem is pathname

exports.leaf = (req, res) ->
  filesystem.getDirList req.param('pathname'), (err, files) =>
    res.set 'Content-Type', 'text/plain'
    if not err and files.length > 0
      res.end 'node'
    else
      res.end 'leaf'

exports.list = (req, res) ->
  pathname = req.param('pathname')
  context =
    pathname: /// ([^/]*)/?$ ///.exec(pathname)[1] # Name of folder
    checked: isChecked(pathname)

  filesystem.getDirList pathname, (err, files) =>
    context.files = []
    if files?
      for file in files
        file.checked = isChecked(file.path)
        context.files.push file
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
          if filesystem.isFolder( file.path )
            file.icon = 'folder'
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
          else if /// (?:\.) (?: 
            mp3 | wav | mpeg |
            ogg | flac | wma |
            webm
           ) $ ///.test(file.path) 
            file.icon = 'audio' 
          else 
            file.icon = 'file'
          file.checked = isChecked(file.path)
          filelist.push file
    context.files = filelist
    res.render 'files', context

