eval "$(fnm env --multi)"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function autoswitch_to_node_version() {
  if [ -f '.nvmrc' ]; then
    requested_node_version="$(cat .nvmrc)"
    fnm use "$requested_node_version"
  fi
}

function context_switch() {
  autoswitch_to_node_version
  # autoswitch_conda_env
  context=$(echo $PWD | sed -E 's/^\/Users\/emurphy\/code\/([^/]+).*$/\1/')
  unset SPACES_ACCESS_KEY_ID
  unset SPACES_SECRET_ACCESS_KEY
  unset DIGITALOCEAN_ACCESS_TOKEN
  unset AWS_PROFILE
  if ! [[ $context =~ / ]]; then
    export AWS_PROFILE=$context
    if [ -d '.git' ]; then
      if [[ "$context" == 'starry' ]]; then
        git config user.name emurphy
        git config user.email emurphy@starry.com
      else
        git config user.name edwmurph
        git config user.email edwmurph3@gmail.com
      fi
    fi
    if [[ "$context" == 'personal' ]]; then
      export SPACES_ACCESS_KEY_ID="${DO_SPACES_ACCESS_KEY_ID}"
      export SPACES_SECRET_ACCESS_KEY="${DO_SPACES_SECRET_ACCESS_KEY}"
      export DIGITALOCEAN_ACCESS_TOKEN="${DO_DIGITALOCEAN_ACCESS_TOKEN}"
      export AWS_ACCESS_KEY_ID="${SPACES_ACCESS_KEY_ID}"
      export AWS_SECRET_ACCESS_KEY="${SPACES_SECRET_ACCESS_KEY}"
    elif [[ "$context" == 'starry' ]]; then
    elif [[ "$context" == 'do' ]]; then
    elif [[ "$context" == 'bitnado' ]]; then
      export SPACES_ACCESS_KEY_ID="${BITNADO_SPACES_ACCESS_KEY_ID}"
      export SPACES_SECRET_ACCESS_KEY="${BITNADO_SPACES_SECRET_ACCESS_KEY}"
      export DIGITALOCEAN_ACCESS_TOKEN="${BITNADO_DIGITALOCEAN_ACCESS_TOKEN}"
      export AWS_ACCESS_KEY_ID="${BITNADO_SPACES_ACCESS_KEY_ID}"
      export AWS_SECRET_ACCESS_KEY="${BITNADO_SPACES_SECRET_ACCESS_KEY}"
    fi
  fi
}


cd () { builtin cd "$@" && context_switch; }
pushd () { builtin pushd "$@" && context_switch; }
popd () { builtin popd "$@" && context_switch; }
cd .
