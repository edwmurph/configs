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

function tt() {
  local gitignore="$(cat .gitignore)"
  local ignore_dirs="$(pipe_deliminate $IGNORE_DIRS)|$(pipe_deliminate $gitignore)"
  local ignore_dirs_escaped="$(echo $ignore_dirs | sed 's/*/\\*/g')"
  tree -a -L 10 -C -f -n -F --noreport "${1-.}" \
    | grep -v -E "$ignore_dirs_escaped" \
    | sed 's/\/$//;s/\/.*\///;s/\..*\///'
}
