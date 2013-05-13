express = require('express')
global.app = express()

app.set 'port', 6600
app.set 'views', './views'
app.set 'view engine', 'jade'

app.use express.logger('dev')
app.use express.static('./public')
app.use express.bodyParser()


template = require('./template.js')
app.get '/', template.root
app.get '/init', template.init
app.get '/help', template.help
app.get '/finish', template.finish

ajax = require('./ajax.js')
app.post '/leaf', ajax.leaf
app.post '/list', ajax.list
app.post '/files', ajax.files

logic = require('./logic.js')
app.post '/add', logic.add
app.post '/remove', logic.remove
app.post '/init-controller', logic.initController 

app.listen app.get('port')
console.log 'Now going to http:/localhost:' + app.get('port') + '/'
