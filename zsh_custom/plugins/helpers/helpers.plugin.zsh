SECRETS="${HOME}/.secrets"

function source_if_exists () {
  path="${1?Must pass a path to source_if_exists}"
  if [[ -f "$path" ]]; then
    . "$path"
  fi
}

function goto() {
  cd ${1}
  # sets the tab title to target directory
  DISABLE_AUTO_TITLE="true"
  echo -ne "\e]1;${1}\a"
}
