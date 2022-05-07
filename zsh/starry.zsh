
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
