function pipe_deliminate() {
  echo $1 | sed '/^#/d;/^$/d' | tr '\n' '|' | sed 's/|$//'
}

IGNORE_DIRS="$(cat $CONFIGS_PATH/zsh/ignore-dirs.ignore)"

function goto() {
  cd ${1-.}
  # commented out because changing tab title messes with opening new split panes
  # sets the tab title to target directory
  echo -e "\033];${PWD/$HOME/~}\007"
}

# initialize on new shell
goto
