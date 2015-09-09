
function reload() {
  source ~/.zshrc
}

function root {
 ssh -t niclas@mietz.io -p 31290 'sudo -i'
}

function nas {
 ssh admin@10.0.0.10
}

function doco {
 docker-compose $1
}


function di {
 $(boot2docker shellinit)
 export DOCKER_HOST=tcp://boot2docker:2376
}

function github {
 git config --local user.name "SolidNerd"
 git config --local user.email "github@mietz.io"
}

function dcr {
 docker stop $1 && docker rm $1
}

function gemdir {
  if [[ -z "$1" ]] ; then
    echo "gemdir expects a parameter, which should be a valid RVM Ruby selector"
  else
    rvm "$1"
    cd $(rvm gemdir)
    pwd
  fi
}
