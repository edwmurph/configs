function gcmsgf() {
  local hash="$(git log --grep "fixup!" --invert-grep -n 1 --format='%H')"
  git commit --fixup $hash -m $1
}

function nrd() {
  local develop=$(node -e 'console.log(require("./package.json").scripts.develop || "")')
  local dev=$(node -e 'console.log(require("./package.json").scripts.dev || "")')

  if [ -n "$develop" ]; then
    npm run develop
  elif [ -n "$dev" ]; then
    npm run dev
  else
    echo 'no dev or develop npm script'
  fi
}

function npm_install_string() {
  local DEP_TYPE=${1}
  local INSTALL_STRING=$(node -e "
  const deps = require('./package.json').${DEP_TYPE} || {};
  const formatted = Object.keys( deps ).map( d => {
    const version = deps[ d ];
    return /^[0-9]+\.[0-9]+\.[0-9]+$/.test( version )
      ? d + '@' + version
      : version;
  });
  formatted.length && console.log( 'npm i --save false', formatted.join(' ') );
  ")
  echo "$INSTALL_STRING"
}

function reset_node_env() {
  fnm use || ( echo 'must run within directory with .nvmrc' && return 1 )

  echo 'deleting node modules...'

  rm -rf node_modules

  local DEPS_INSTALL="$(npm_install_string dependencies)"
  local DEV_DEPS_INSTALL="$(npm_install_string devDependencies)"

  if [ -n $DEPS_INSTALL ]; then
    echo 'installing dependencies...'
    echo "$DEPS_INSTALL" | zsh
    echo ''
  fi

  if [ -n $DEV_DEPS_INSTALL ]; then
    echo 'installing dev dependencies...'
    echo "$DEV_DEPS_INSTALL" | zsh
    echo ''
  fi

  echo 'successfully reset local node env!'
}

function get_gitignore() {
  local gitignore=''

  for ups in {2..0};
  do
    p="$(printf '%*s' "$ups" | sed 's/ /..\//g').gitignore"

    if [ -f $p ]; then
      gitignore=$p
    fi
  done

  echo $gitignore
}

function cl() {
  curl -s -i $1 | sed -e 1b -e '$!d'
}

function dd() {
  docker exec -it ${1?expected container id to enter} /bin/bash
}

function gsetup() {
  if [ "$1" = 'starry' ]; then
    local name='edwmurph'
    local email='emurphy@starry.com'
  else
    local name='edwmurph'
    local email='edwmurph3@gmail.com'
  fi

  git config user.name $name
  git config user.email $email
}

function greset() {
  git filter-branch -f --env-filter "
  GIT_AUTHOR_NAME='edwmurph'
  GIT_AUTHOR_EMAIL='edwmurph3@gmail.com'
  GIT_COMMITTER_NAME='edwmurph'
  GIT_COMMITTER_EMAIL='edwmurph3@gmail.com'
  " HEAD
}

function fzfpreview() {
  fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
}

function v() {
  file="$(fzfpreview)"
  if [ -n "$file" ]; then
    vim "$file"
  fi
  print -S "vim $file"
}

function vn() {
  file="$(find node_modules | fzfpreview)"
  if [ -n "$file" ]; then
    vim "$file"
  fi
  print -S "vim $file"
}

function jarvis() {
  source "${SECRETS}/secrets.zsh"

  # send first arg as msg if provided or wait for msg from stdin
  local msg=$1

  if [ $# -eq 0 ]; then
    read msg
  fi

  curl -H "Content-Type: application/json" \
    -X POST \
    -d "{\"content\":\"${msg}\"}" \
    $DISCORD_JARVIS
}

# find target and replace with replacement
function far() {
  TARGET="${1?missing target}"
  REPLACEMENT="${2?missing replacement}"

  git grep -l '' | xargs sed -i '' -e "s/${TARGET}/${REPLACEMENT}/g"
}

function dc() {
  local usage='usage: dc [container id] [path on container to copy]'
  docker cp ${1?$usage}:${2?$usage} ./
}

function kcy() {
  local usage='usage: kcy [namespace] [pod] [path on container to copy]'
  kubectl cp ${1?$usage}/${2?$usage}:${3?$usage} ./
}
