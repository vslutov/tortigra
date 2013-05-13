filesystem = require('./filesystem.js')
require('sugar')

app.locals.task = []
app.locals.started = false

isParent = (parent, pathname) ->
  pathname.startsWith(parent) and parent.endsWith('/') or parent is ''

remove = (task, pathname, callback) -> # Recursive function
  parent = task.find (elem) -> isParent(elem, pathname) or elem is pathname
  if parent isnt pathname
    task.remove parent
    filesystem.readdir parent, (err, files) =>
      for file in files
        if filesystem.statSync(parent + file).isDirectory()
          task.push parent + file + '/'
        else
          task.push parent + file
      remove task, pathname, callback
  else
    task.remove pathname
    callback task

exports.add = (req, res) ->
  pathname = req.param('pathname') 
  app.locals.task.remove (elem) -> isParent(pathname, elem)
  app.locals.task.push pathname
  console.log app.locals.task
  res.end 'ok'

exports.remove = (req, res) ->
  pathname = req.param('pathname')
  remove app.locals.task, pathname, (apply) =>
    app.locals.task = apply
    console.log app.locals.task
    res.end 'ok'

app.locals.source = '/source/'
app.locals.destination = '/destination/'

exports.initController = (req, res) ->
  app.locals.source = req.param('source')
  app.locals.destination = req.param('destination')
  res.redirect '/'