exports.root = (req, res) ->
  res.render 'index', {title: 'Home'}

exports.init = (req, res) ->
  res.render 'init', {title: 'Init'}

exports.help = (req, res) ->
  res.render 'help', {title: 'Help'}