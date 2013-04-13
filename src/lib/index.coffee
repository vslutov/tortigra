express = require('express')
filesystem = require('./filesystem.js')
content = require('./content.js')
require('sugar')

global.app = express()

app.set 'tortigra source', 'C:/'
app.set 'tortigra destination', '/dest/'

app.set 'port', 6600
app.set 'views', './views'
app.set 'view engine', 'jade'


app.use express.logger('dev')
app.use express.static('./public')
app.use express.bodyParser()

app.get '/', content.root
app.get '/init', content.init
app.get '/help', content.help

app.post '/leaf', filesystem.leaf
app.post '/init-controller', filesystem.initController 
app.post '/list', filesystem.list
app.post '/files', filesystem.files


app.listen app.get('port')
console.log 'Now going to http:/localhost:' + app.get('port') + '/'
