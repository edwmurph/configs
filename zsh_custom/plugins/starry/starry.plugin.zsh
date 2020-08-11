# navigation
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
  alias sms='goto ~/code/starry/maestro'
  alias smsc='goto ~/code/starry/maestro-client'

# git
  #alias gcd='git checkout develop'

# mongo
  # alias smongo='docker exec -it $(docker ps -aqf "name=mongodb.cloudenv") mongo'

  function smongo() {
    source "${SECRETS}/secrets.zsh"

    if [ -z $1 ]; then
      local conn_url=''
    elif [ "$1" = "storm" ]; then
      local conn_url="$STARRY_MONGO_CONN_STR_STORM"
    elif [ "$1" = 'radius' ]; then
      local conn_url="$STARRY_MONGO_CONN_STR_RADIUS"
    fi

    echo "conn_url: '$conn_url'"

    docker exec -it $(docker ps -aqf "name=mongodb.cloudenv") mongo $conn_url
  }
  
