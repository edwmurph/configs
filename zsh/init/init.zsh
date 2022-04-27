function pipe_deliminate() {
  echo $1 | sed '/^#/d;/^$/d' | tr '\n' '|' | sed 's/|$//'
}

IGNORE_DIRS="$(cat $CONFIGS_PATH/zsh/ignore-dirs.txt)"

function goto() {
  cd ${1-.}
  # sets the tab title to target directory
  echo -e "\033];$(pwd)\007"
}

# initialize on new shell
goto
