
alias ssk="goto ~/code/starry/seeker"
alias sra="goto ~/code/starry/radius-accounting"
alias smm="goto ~/code/starry/mimir"
alias sgf="goto ~/code/starry/grafana"
alias shp="goto ~/code/starry/hapi-plugins"
alias sjv="goto ~/code/starry/jarvis"
alias sce="goto ~/code/starry/cloud-env"
alias sst="goto ~/code/starry/storm"
alias saa="goto ~/code/starry/admin-api-v2"
alias sbs="goto ~/code/starry/banshee"
alias stu="goto ~/code/starry/starry-test-utils"
alias sza2="goto ~/code/starry/zoma-v2"
alias sam="goto ~/code/starry/amp"

function s() {
  goto ~/code/starry/${1?USAGE s <reponame>}
}

function cdt() {
  local CDT="$HOME/code/starry/cloud-dev-tools"
  local OLD_NODE_VERSION="$(node -v)"
  local NEW_NODE_VERSION="$(cat $CDT/.nvmrc)"

  fnm use $NEW_NODE_VERSION 1> /dev/null

  $CDT/shared_scripts/commander.js "$@"

  fnm use $OLD_NODE_VERSION 1> /dev/null
}

function secr() {
  aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS --password-stdin \
    $STARRY_ECR
}

function smongo() {
  if [ -z $1 ]; then
    local conn_url=''
  elif [ "$1" = "storm" ]; then
    local conn_url="$STARRY_MONGO_CONN_STR_STORM"
  fi

  echo "conn_url: '$conn_url'"

  docker exec -it $(docker ps -aqf "name=mongodb.cloudenv") mongo $conn_url
}

function sdecrypt() {
  local cipher="${1?USAGE: decrypt <cipher>}"

  node -e "require('enigma').decrypt('${cipher}').then(console.log, console.log)"
}

function stunnel_ip() {
  ssh -o 'CheckHostIP=no' -o 'IdentitiesOnly=yes' \
    -i ${SECRETS}/dotfiles/.ssh/starry/aws/edward.pem \
    -J cloudvpn "ubuntu@${1?missing ip}"
}

function stunnel_db() {
  ssh -4 -A -L local.cloud.starry.com:27019:${1?missing db endpoint to tunnel} cloudvpn -N -v
}

function stunnel_mongo2() {
  stunnel_db mongo-production-replset2-02.cloud.starry.com:27017
}

# mongosh \
# --verbose \
# --host local.cloud.starry.com \
# --username emurphy \
# --password <redacted> \
# --port 27019 \
# --authenticationMechanism SCRAM-SHA-1 \
# --authenticationDatabase admin \
# --tls \
# --tlsCAFile /Users/emurphy/.secrets/starry/ca.crt \
# --tlsAllowInvalidHostnames
