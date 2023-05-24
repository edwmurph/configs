function cdt() {
  local CDT="$HOME/code/starry/cloud-dev-tools"
  local OLD_NODE_VERSION="$(node -v)"
  local NEW_NODE_VERSION="$(cat $CDT/.nvmrc)"

  fnm use $NEW_NODE_VERSION 1> /dev/null

  $CDT/shared_scripts/commander.js "$@"

  fnm use $OLD_NODE_VERSION 1> /dev/null
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
