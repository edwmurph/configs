SECRETS="${HOME}/.secrets"

# navigation
  alias sbs='goto ~/code/starry/banshee'
  alias sose='goto ~/code/starry/outset'
  alias smi='goto ~/code/starry/mimir'
  alias shs='goto ~/code/starry/hindsight'
  alias sdsp='goto ~/code/starry/docker-socket-proxy'
  alias sosl='goto ~/code/starry/onslaught'
  alias sal='goto ~/code/starry/amp-logger'
  alias snb='goto ~/code/starry/node-builder'
  alias scr='goto ~/code/starry/cerebro'
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
  alias sbcs='goto ~/code/starry/backchannel-server'
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

function elb_access_log() {
  aws s3 cp s3://starry-radius-accounting-elb-logs/${1?need s3 object key } log.log
}

function secr() {
  aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS --password-stdin \
    $STARRY_ECR
}

function stunnel_db() {
  ssh -L 27019:${1?missing db endpoint to tunnel}:27000 cloudvpn
}

function stunnel_mongo2() {
  ssh -L 27019:${STARRY_MONGO_2}:27017 cloudvpn
}

function stunnel_dbs() {
  ssh cloudvpn \
    -L 27020:${STARRY_MONGO_INTEGRATION_0}:27000 \
    -L 27021:${STARRY_MONGO_INTEGRATION_1}:27000 \
    -L 27022:${STARRY_MONGO_INTEGRATION_2}:27000
}

function stunnel() {
  local USAGE='USAGE: stunnel <SERVICE> <ENV>'
  local SERVICE=${1?USAGE: stunnel <SERVICE> <ENV>}
  local ENV=${2?USAGE: stunnel <SERVICE> <ENV>}

  INSTANCES="$(
    aws ec2 describe-instances \
    --filters \
    Name=tag:service,Values=$SERVICE \
    Name=tag:environment,Values=$ENV \
    Name=tag:service_type,Values=stormsvc \
    Name=instance-state-name,Values=running \
    --query 'Reservations[].Instances[].[LaunchTime, InstanceId, Placement.AvailabilityZone, PrivateIpAddress]' \
    --output text
  )"

  if [ -z "$INSTANCES" ]; then
    echo "Unable to find any instances for service=$SERVICE env=$ENV"
    return 0
  fi

  NUM_INSTANCES=$(echo "$INSTANCES" | wc -l | xargs)
  printf "Instances for $SERVICE $ENV:\n\n$( echo "$INSTANCES" | nl )\n\n"

  # prompt for instance
  while [ -z "$SELECTED" ]; do
    read '?Give the number corresponding to the instance you would like to SSH into: ' SELECTED

    if [[ ! "$SELECTED" =~ ^[0-9]$ ]] || [ $SELECTED -gt $NUM_INSTANCES ] || [ $SELECTED -lt 1 ]; then
      printf "Invalid selection '$SELECTED'. Pick a number between 1 and ${NUM_INSTANCES}\n"
      unset SELECTED
    fi
  done

  INSTANCE=$(echo "$INSTANCES" | sed -n "${SELECTED}p")
  PRIVATE_IP=$(echo "$INSTANCE" | awk '{print $4}')

  echo ''
  echo "PRIVATE_IP=$PRIVATE_IP"
  echo ''

  stunnel_ip $PRIVATE_IP
}

function stunnel_ip() {
  ssh -o 'CheckHostIP=no' -o 'IdentitiesOnly=yes' -i ${SECRETS}/dotfiles/.ssh/starry/aws/edward.pem -J cloudvpn "ubuntu@${1?missing ip}"
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

function lambda_logs() {
  local lambda=${1?usage: lambda_logs [lambda name] [limit=10]}
  local limit=${2-10}

  local log_stream_name="$(
    aws logs describe-log-streams --log-group-name /aws/lambda/$lambda \
      --query 'sort_by(logStreams, &creationTime)[-1].logStreamName' \
      --output json \
      | sed 's/"//g'
  )"

  aws logs get-log-events \
    --log-group-name /aws/lambda/$lambda \
    --log-stream-name $log_stream_name \
    --limit $limit
}

function maestro() {
  local MAESTRO_PATH=${1?usage: maestro [path]}

  node -e \
  "require('maestro-client').get('$MAESTRO_PATH')
    .then(console.log, console.error)
    .finally(() => process.exit(0))"
}
