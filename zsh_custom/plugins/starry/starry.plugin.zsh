SECRETS="${HOME}/.secrets"

# navigation
  alias scb='goto ~/code/starry/cerebro'
  alias spf='goto ~/code/starry/padfoot'
  alias sgf='goto ~/code/starry/grafana'
  alias sza='goto ~/code/starry/zoma'
  alias slc='goto ~/code/starry/lockbox-client'
  alias shp='goto ~/code/starry/hapi-plugins'
  alias sra='goto ~/code/starry/radius-accounting'
  alias sts='goto ~/code/starry/telegraf-server'
  alias stu='goto ~/code/starry/starry-test-utils'
  alias sam='goto ~/code/starry/amp'
  alias sce='goto ~/code/starry/cloud-env'
  alias sls='goto ~/code/starry/locksmith'
  alias sjv='goto ~/code/starry/jarvis'
  alias spp='goto ~/code/starry/pepper'
  alias ssage='goto ~/code/starry/sage'
  alias ssa='goto ~/code/starry/stats-api'
  alias szl='goto ~/code/starry/ziploc'
  alias saa='goto ~/code/starry/admin-api-v2'
  alias sap='goto ~/code/starry/auth-proxy'
  alias sca='goto ~/code/starry/cloud-api'
  alias srs='goto ~/code/starry/radius-server'
  alias scm='goto ~/code/starry/cloud-models'
  alias sdh='goto ~/code/starry/dullahan'
  alias spa='goto ~/code/starry/places-api'
  alias sua='goto ~/code/starry/upgrader-api'
  alias sbs='goto ~/code/starry/backchannel-server'
  alias sbt='goto ~/code/starry/bastion'
  alias slk='goto ~/code/starry/lakitu'
  alias sfg='goto ~/code/starry/forge'
  alias sst='goto ~/code/starry/storm'
  alias slb='goto ~/code/starry/lockbox'
  alias smm='goto ~/code/starry/map-memo'
  alias smo='goto ~/code/starry/maestro'
  alias smc='goto ~/code/starry/maestro-client'
  alias sms='goto ~/code/starry/maestro-services'

# git
  #alias gcd='git checkout develop'

function stunnel_db() {
  ssh -L 27019:${STARRY_MONGO_RADIUS_ACCT_INTEGRATION}:27000 cloudvpn
}

function stunnel_dbs() {
  ssh cloudvpn \
    -L 27020:${STARRY_MONGO_INTEGRATION_0}:27000 \
    -L 27021:${STARRY_MONGO_INTEGRATION_1}:27000 \
    -L 27022:${STARRY_MONGO_INTEGRATION_2}:27000
}

function stunnel() {
  ssh -i ${SECRETS}/dotfiles/.ssh/starry/aws/edward.pem -J cloudvpn "ubuntu@${1?missing ip}"
}

alias smongob='docker exec -it $(docker ps -aqf "name=mongodb.cloudenv") /bin/bash'

function smongo() {
  source "${SECRETS}/secrets.zsh"

  if [ -z $1 ]; then
    local conn_url=''
  elif [ "$1" = "storm" ]; then
    local conn_url="$STARRY_MONGO_CONN_STR_STORM"
  elif [ "$1" = 'radius-server' ]; then
    local conn_url="$STARRY_MONGO_CONN_STR_RADIUS"
  fi

  echo "conn_url: '$conn_url'"

  docker exec -it $(docker ps -aqf "name=mongodb.cloudenv") mongo $conn_url
}
  

function sredis() {
  docker exec -it $(docker ps -aqf "name=redis.cloudenv") redis-cli
}

function cloudwatch_img() {
    # "start": "",
    # "end": "",
  aws cloudwatch get-metric-widget-image --metric-widget \
'{
    "width": 600,
    "height": 395,
    "metrics": [
        [ "AWS/DocDB", "CPUUtilization", "DBInstanceIdentifier", "radius-accounting-integration", { "stat": "Maximum" } ]
    ],
    "period": 300,
    "stacked": false,
    "title": "CPU",
    "view": "timeSeries"
}' \
  | grep MetricWidgetImage \
  | awk '{split($0,a,"\""); print a[4]}' \
  | base64 --decode \
  > graph.png
}
