filesystem = require('./filesystem.js')
nextTick = process.nextTick
require('sugar')

app.locals.stage = 'not started'

remove = (task, pathname, callback) -> # Recursive function
  parent = task.find (elem) -> filesystem.isParent(elem, pathname) or elem is pathname
  if parent isnt pathname
    task.remove parent
    filesystem.readFolder parent, (err, files) =>
      task.add files
      remove task, pathname, callback
  else
    task.remove pathname
    callback task

app.locals.alreadyDone = 0
doWork = () ->
  if app.locals.task.length isnt app.locals.alreadyDone
    elem = app.locals.task[app.locals.alreadyDone]
    ++app.locals.alreadyDone
    if filesystem.isFolder(elem)
      filesystem.readFolder elem, (err, files) =>
        if files?
          app.locals.task.add files
        filesystem.copyFolder elem, () =>
          doWork()
    else
      filesystem.copyFile elem, () =>
        doWork()
  else
    app.locals.stage = 'finished'

exports.add = (req, res) ->
  pathname = req.param('pathname') 
  app.locals.task.remove (elem) -> filesystem.isParent(pathname, elem)
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
  app.locals.task = []
  app.locals.stage = 'started'
  res.redirect '/'

exports.finishController = (req, res) ->
  app.locals.stage = 'wait'
  doWork()
  res.redirect '/'