require 'shelljs/global'
fs = require 'fs'
express = require 'express'
tacobot = express()
execFile = require('child_process').execFile

tacobot.use express.logger(stream: fs.createWriteStream('tacobot.access.log', {'flags': 'w'}))

tacobot.get '/', (request, response) ->
  response.send """
<!doctype html>
<html>
  <head>
  </head>
  <body>
    Hello. My name is <a href="http://github.com/tacobot">Inigo Montaco</a>. You killed my father. Prepare to dine.
  </body>
</html>
"""

tacobot.post '/update', (request, response) ->
  response.send "Checking..."
  console.log new Date()
  if not which 'git'
    echo 'Sorry, this script requires git'
    exit 1

  repo_path = '../tacofancy'
  cd repo_path
  exec 'git pull', (pull_code, pull_output) ->
    exec 'cake build:toc', (build_code, build_output) ->
      exec 'git status', (status_code, status_output) ->
        for line in status_output.split('\n') when line.match(/#\s+modified:\s+(\S+)/i)
          do (line) -> 
            path = line.match(/#\s+modified:\s+(\S+)/i)?[1]
            exec 'GIT_AUTHOR_EMAIL=tacobot@knowtheory.net GIT_AUTHOR_NAME=tacobot git commit -a -m "Updating index"', (commit_code, commit_output) ->
              exec 'git push' # try not pushing for every line.
  
tacobot.listen 6534
