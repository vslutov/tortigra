exports.root = (req, res) ->
  context = 
    title: 'Home'
    dirpath: ''
    dirname: app.get('tortigra source')
  res.render 'index', context

exports.init = (req, res) ->
  res.render 'init', {title: 'Init'}

exports.help = (req, res) ->
  res.render 'help', {title: 'Help'}