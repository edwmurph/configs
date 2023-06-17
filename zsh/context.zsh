eval "$(fnm env)"

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

  git config --global user.name "edwmurph"
  git config --global user.email 20996513+edwmurph@users.noreply.github.com

  unset SPACES_ACCESS_KEY_ID
  unset SPACES_SECRET_ACCESS_KEY
  unset DIGITALOCEAN_ACCESS_TOKEN
  unset AWS_PROFILE
  unset GOOGLE_CREDENTIALS
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  if ! [[ $context =~ / ]]; then
    if [[ "$context" == 'personal' ]]; then
      export AWS_PROFILE=edwmurph
      # export SPACES_ACCESS_KEY_ID="${DO_SPACES_ACCESS_KEY_ID}"
      # export SPACES_SECRET_ACCESS_KEY="${DO_SPACES_SECRET_ACCESS_KEY}"
      # export DIGITALOCEAN_ACCESS_TOKEN="${DO_DIGITALOCEAN_ACCESS_TOKEN}"

      # export GOOGLE_CREDENTIALS="${PERSONAL_GOOGLE_CREDENTIALS}"
      export ZEROTIER_CENTRAL_TOKEN="${PERSONAL_ZEROTIER_CENTRAL_TOKEN}"
      export DIGITALOCEAN_TOKEN="${PERSONAL_DIGITALOCEAN_TOKEN}"
    elif [[ "$context" == 'starry' ]]; then
    elif [[ "$context" == 'do' ]]; then
    elif [[ "$context" == 'bitforge' ]]; then
      export AWS_PROFILE=$context
      export SPACES_ACCESS_KEY_ID="${BITNADO_SPACES_ACCESS_KEY_ID}"
      export SPACES_SECRET_ACCESS_KEY="${BITNADO_SPACES_SECRET_ACCESS_KEY}"
      export DIGITALOCEAN_ACCESS_TOKEN="${BITNADO_DIGITALOCEAN_ACCESS_TOKEN}"
      export AWS_ACCESS_KEY_ID="${BITNADO_SPACES_ACCESS_KEY_ID}"
      export AWS_SECRET_ACCESS_KEY="${BITNADO_SPACES_SECRET_ACCESS_KEY}"
      export GOOGLE_CREDENTIALS="${BITFORGE_GOOGLE_CREDENTIALS}"
      export ZEROTIER_CENTRAL_TOKEN="${BITFORGE_ZEROTIER_CENTRAL_TOKEN}"
    fi
  fi
}

function chpwd () {
  context_switch
  echo -e "\033];${PWD/$HOME/~}\007"
}

cd .
