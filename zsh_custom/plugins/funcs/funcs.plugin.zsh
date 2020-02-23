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
  git config user.name edwmurph
  git config user.email edwmurph3@gmail.com
}

function greset() {
  git filter-branch -f --env-filter "
  GIT_AUTHOR_NAME='edwmurph'
  GIT_AUTHOR_EMAIL='edwmurph3@gmail.com'
  GIT_COMMITTER_NAME='edwmurph'
  GIT_COMMITTER_EMAIL='edwmurph3@gmail.com'
  " HEAD
}

function v() {
  file="$(fzf)"
  if [ -n "$file" ]; then
    vim "$file"
  fi
  print -S "vim $file"
}

function vn() {
  file="$(find node_modules | fzf)"
  if [ -n "$file" ]; then
    vim "$file"
  fi
  print -S "vim $file"
}

function gd() {
  git diff "${2-HEAD}" -- "${1-.}" ':(exclude)*package-lock.json'
}

function gdd() {
  git diff HEAD^ -- "${1-.}" ':!*package-lock.json' ':!*pnpm-lock.yaml'
}
