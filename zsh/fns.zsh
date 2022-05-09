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
    --preview-window up:80%,border-horizontal
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

  if [ -n $gitignore_path ]; then
    local gitignore="$(cat $gitignore_path)"
  else
    local gitignore=''
  fi

  local ignore_dirs="$(pipe_deliminate $IGNORE_DIRS)|$(pipe_deliminate $gitignore)"
  local ignore_dirs_escaped="$(echo $ignore_dirs | sed 's/*/\\*/g')"

  tree -a -L 10 -C -n -F --noreport "${1-.}" \
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
  EDITOR=true git rebase -i --autosquash $(git rev-parse --abbrev-ref HEAD)
}
