filesystem = require('./filesystem.js')
require('sugar')

task = []

exports.add = (req, res) ->
  pathname = req.param('pathname')
  if task.count(pathname) is 0 then task.push(pathname)
  console.log task
  res.end 'ok'

exports.remove = (req, res) ->
  pathname = req.param('pathname')
  if task.count(pathname) isnt 0 then task.remove(pathname)
  console.log task
  res.end 'ok'