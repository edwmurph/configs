function pipe_deliminate() {
  echo $1 | sed '/^#/d;/^$/d' | tr '\n' '|' | sed 's/|$//'
}

IGNORE_DIRS="$(cat $CONFIGS_PATH/zsh/ignore-dirs.txt)"
