exports.root = (req, res) ->
  if app.locals.started
    res.render 'index', {title: 'Home'}
  else
    exports.help(req, res)

exports.init = (req, res) ->
  res.render 'init', {title: 'Init'}

exports.help = (req, res) ->
  res.render 'help', {title: 'Help'}

exports.finish = (req, res) ->
  res.render 'finish', {title: 'Finish'}