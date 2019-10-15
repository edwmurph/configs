SECRETS="${HOME}/.secrets"

function source_if_exists () {
  path="${1?Must pass a path to source_if_exists}"
  if [[ -f "$path" ]]; then
    . "$path"
  fi
}

function goto() {
  cd ${1} && echo -ne "\033]0;"${1}"\007"
}
