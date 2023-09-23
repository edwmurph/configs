function dt() {
  (cd ~/code/personal/dev-tools && node index.mjs "$@")
}

function enqueue() {
  local QUEUE_URL=${1?USAGE: enqueue <QUEUE_URL> <PROFILE?>}
  local PROFILE=${2-edwmurph}

  for i in {1..10}; do
    aws sqs send-message \
      --queue-url $QUEUE_URL \
      --profile $PROFILE \
      --message-group-id 'test' \
      --message-body $i
    if [ $? -ne 0 ]; then
      return
    fi
  done
}

function invoke() {
  local FUNCTION_NAME=${1?USAGE: invoke <FUNCTION_NAME> <PAYLOAD?> <PROFILE?>}
  local PAYLOAD=${2-'{}'}
  local PROFILE=${3-'edwmurph'}
  local OUT_FILE='out.txt'

  aws lambda invoke \
    --function-name $FUNCTION_NAME \
    --cli-binary-format raw-in-base64-out \
    --payload $PAYLOAD \
    --profile $PROFILE \
    --log-type Tail $OUT_FILE \
    --query 'LogResult' \
    --output text \
    | base64 -d

  rm $OUT_FILE
}

function invoke_url() {
  local LAMBDA_URL=${1?USAGE: invoke_url <LAMBDA_URL> <PAYLOAD?> <PROFILE?>}
  local PAYLOAD=${2-'{}'}
  local PROFILE=${3-edwmurph}

  awscurl \
    --service lambda \
    $LAMBDA_URL \
    --profile $PROFILE \
    -d $PAYLOAD
}

function pssh() {
  local IP=${1?USAGE: pssh <public ip>}
  ssh -i ~/.secrets/dotfiles/.ssh/aws/my-key-pair.pem ec2-user@$IP
}

# find first instance of given file by looking upwards
function upfind() {
  local curr=$PWD
  while [[ "$curr" != / ]] ; do
    if find "$curr"/ -maxdepth 1 -type f -name "$@" | grep -q "$@"; then
      echo "$curr/$1"
      return 0
    else
      curr="$(dirname $curr)"
    fi
  done
  return 1
}

function fzf_custom() {
  fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' \
    --preview-window up:65%,border-horizontal
}

function v() {
  file="$(fzf_custom)"
  if [ -n "$file" ]; then
    vim "$file"
  fi
  print -S "vim $file"
}

function vn() {
  file="$(find node_modules | fzf_custom)"
  if [ -n "$file" ]; then
    vim "$file"
  fi
  print -S "vim $file"
}

function tt() {
  local gitignore_path="$(upfind .gitignore)"

  if [ -n "$gitignore_path" ]; then
    local gitignore="$(cat $gitignore_path)"
  else
    local gitignore='.git'
  fi

  # local ignore_dirs="$(pipe_deliminate $IGNORE_DIRS)|$(pipe_deliminate $gitignore)"
  local ignore_dirs="$(pipe_deliminate $IGNORE_DIRS)"
  local ignore_dirs_escaped="$(echo $ignore_dirs | sed 's/*/\\*/g')"

  tree -a -L 10 -C -F -I $ignore_dirs --noreport "${1-.}" \
    | grep -v -E "$ignore_dirs_escaped"
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

function gcmsgf() {
  local hash="$(git log --grep "fixup!" --invert-grep -n 1 --format='%H')"
  git commit --fixup $hash -m $1
}

function autosquash() {
  EDITOR=true git rebase -i --autosquash ${1?USAGE:autosquash <branch>}
}

function p() {
  goto ~/code/personal/${1?USAGE p <reponame>}
}

function docker_it() {
  local image=${1?USAGE:docker_it <image> <command?>}
  local command=${2-/bin/bash}
  local container_id=$(docker run -d $1 sleep infinity)
  docker exec -it $container_id $command
}

function groh() {
  git reset --hard origin/$(git branch --show-current)
}
