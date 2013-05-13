filesystem = require('./filesystem.js')
nextTick = process.nextTick
require('sugar')

app.locals.task = ['audio/music/']
app.locals.stage = 'not started'

isParent = (parent, pathname) ->
  pathname.startsWith(parent) and filesystem.isFolder(parent)

remove = (task, pathname, callback) -> # Recursive function
  parent = task.find (elem) -> isParent(elem, pathname) or elem is pathname
  if parent isnt pathname
    task.remove parent
    filesystem.readFolder parent, (err, files) =>
      for file in files
        task.push file
      remove task, pathname, callback
  else
    task.remove pathname
    callback task

now = 0
doWork = () ->
  if app.locals.task.length isnt now
    elem = app.locals.task[now]
    ++now
    if filesystem.isFolder(elem)
      filesystem.readFolder elem, (err, files) =>
        if files?
          app.locals.task.add files
        nextTick doWork
  else
    app.locals.stage = 'finished'

exports.add = (req, res) ->
  pathname = req.param('pathname') 
  app.locals.task.remove (elem) -> isParent(pathname, elem)
  app.locals.task.push pathname
  res.end 'ok'

exports.remove = (req, res) ->
  pathname = req.param('pathname')
  remove app.locals.task, pathname, (apply) =>
    app.locals.task = apply
    res.end 'ok'

exports.initController = (req, res) ->
  app.locals.source = req.param('source')
  app.locals.destination = req.param('destination')
  app.locals.stage = 'started'
  res.redirect '/'

exports.finishController = (req, res) ->
  app.locals.stage = 'wait'
  nextTick doWork
  res.redirect '/'