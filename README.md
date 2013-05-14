# Tortigra #

## License ##
Tortigra, simple copy assistant

Copyright (C) 2013 V. S. Lutov

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/

## Install guide ##
1. Install [nodejs][1]
2. Clone repository
3. Run `npm install` from folder with code
4. Run `node start.js`

## Why Tortigra? ##
Tortigra - is simple way to copy files with folder hierarchy to portable device.

## Models and Algorithms ##
1. [Event-driven programming][2]
2. [Express framework][3]
3. [Folder tree][4]

### Event-driven programming ###
Flow of the program is determined by events (user actions and filesystem state)

In this code we will add files to task after reading folder (long operation):

    if parent isnt pathname
      task.remove parent
      filesystem.readFolder parent, (err, files) =>
        task.add files
        remove task, pathname, callback

### Express framework ###
Web application framework for node allow to build simple program, for example:

    express = require('express')
    global.app = express()

    app.set 'port', 6600
    app.set 'views', './views'
    app.set 'view engine', 'jade'

    app.get '/init', (req, res) ->
      res.render 'init', {title: 'Init'}

    app.listen(app.get('port'))

### Folder tree ###
It's array containing current task (files and folders to copy). Special rules allow successfully use this data structure:

1. Filename never ends with `/`
2. Dirname always ends with `/`
3. If there is folder, there is no its children.

## For developer ##

### Overview ###
`./src/lib/` contain main files.

- `ajax.coffee` - on the air information view (like folder tree and file list)
- `filesystem.coffee` - low-level function (like readFolder and copyFile)
- `index.coffee` - connector
- `logic.coffee` - some server-side logic (like initController and doWork)
- `template.coffe` - visible part of interface (like help and license)

Task is preserve by array `global.app.locals.task`

### Main functions ###

- `ajax.list(req, res)` - respond to client node in folder tree
- `ajax.files(req, res)` - respond to client files view
- `filesystem.readFolder( pathname, callback(fileArray) )` - read dir and return good pathname `parent/file.ext` or `parent/folder/`
- `filesystem.copyFile(pathname, callback)` and `filesystem.copyFolder(pathname, callback)` - obviously
- `logic.coffee#remove(task, pathname, callback)` - reqoursive remove parents of element from task and add this children
- `logic.coffee#doWork()` - start real copy

### TODO ###
- Add socket.io library
- Add normal select start folder interface
- Add on the air copy
- Add complete dialog

## References ##

+ [Bootstrap](http://twitter.github.io/bootstrap/index.html)
+ [CoffeeScript](http://coffeescript.org/)
+ [Express - node.js web application framework](http://expressjs.com/)
+ [Jade - template engine](https://github.com/visionmedia/jade)
+ [jQuery](http://jquery.com/)
+ [LESS << The Dynamic Stylesheet language](http://lesscss.org/)
+ [node.js](http://nodejs.org/)
+ [Sugar: A Javascript library for working with native objects.](http://sugarjs.com/)


[1]: http://nodejs.org/ 'site:nodejs'
[2]: http://en.wikipedia.org/wiki/Event-driven_programming 'wiki:Event-driven programming'
[3]: http://expressjs.com/ 'site:Express framework'
[4]: http://en.wikipedia.org/wiki/Tree_structure 'wiki:Tree structure'