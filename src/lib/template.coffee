exports.root = (req, res) ->
  if app.locals.stage is 'not started'
    exports.help(req, res)
  else if app.locals.stage is 'started'
    res.render 'index', {title: 'Home'}
  else if app.locals.stage is 'wait'
    res.render 'wait', {title: 'Wait'}
  else #Completed
    res.render 'completed', {title: 'Completed'}

exports.init = (req, res) ->
  res.render 'init', {title: 'Init'}

exports.help = (req, res) ->
  res.render 'help', {title: 'Help'}

exports.finish = (req, res) ->
  res.render 'finish', {title: 'Finish'}