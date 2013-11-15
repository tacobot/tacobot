require 'shelljs/global'

if not which 'git'
  echo 'Sorry, this script requires git'
  exit 1
  
repo_path = '/Users/ted/Code/tacofancy'
cd repo_path
exec 'git pull', (pull_code, pull_output) ->
  exec 'cake build:toc', (build_code, build_output) ->
    exec 'git status', (status_code, status_output) ->
      for line in status_output.split('\n') when line.match(/#\s+modified:\s+(\S+)/i)
        do (line) -> 
          path = line.match(/#\s+modified:\s+(\S+)/i)?[1]
          exec 'git commit -a -m "Updating index"', (commit_code, commit_output) ->
            exec 'git push'
            

