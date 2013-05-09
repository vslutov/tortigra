express = require('express')
global.app = express()

ajax = require('./ajax.js')
template = require('./template.js')
logic = require('./logic.js')

app.locals.source = '/'
app.locals.destination = '/dest/'

app.set 'port', 6600
app.set 'views', './views'
app.set 'view engine', 'jade'


app.use express.logger('dev')
app.use express.static('./public')
app.use express.bodyParser()

app.get '/', template.root
app.get '/init', template.init
app.get '/help', template.help

app.post '/leaf', ajax.leaf
app.post '/init-controller', ajax.initController 
app.post '/list', ajax.list
app.post '/files', ajax.files

app.post '/add', logic.add
app.post '/remove', logic.remove

app.listen app.get('port')
console.log 'Now going to http:/localhost:' + app.get('port') + '/'
