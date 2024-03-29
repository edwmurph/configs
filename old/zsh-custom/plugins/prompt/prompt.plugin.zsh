# Echoes information about Git repository status when inside a Git repository
git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%F{red}%n%f⇡NUM%{$reset_color%}"
  local BEHIND="%F{cyan}%n%f⇣NUM%{$reset_color%}"
  local MERGING="%F{magenta}%n%f⚡︎%{$reset_color%}"
  local UNTRACKED="%F{red}%n%f●%{$reset_color%}"
  local MODIFIED="%F{yellow}%n%f●%{$reset_color%}"
  local STAGED="%F{green}%n%f●%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "±" )
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "$GIT_LOCATION%{$reset_color%}" )
  echo "${(j: :)GIT_INFO}"
}

function get_pwd() {
  echo "${PWD/$HOME/~}"
}

function preexec() {
    timer=${timer:-$SECONDS}
}

function get_prompt() {
  echo '%F{blue}%n%f '${1-0}s %D{%L:%M:%S}'%F{white}%n%f' $(get_pwd)⟩' '
}

function precmd() {
    if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        timer_show=$(printf '%d\n' $timer_show)
        PROMPT=$(get_prompt ${timer_show})
        RPROMPT=$(git_info)
        unset timer
    fi
}

PROMPT=$(get_prompt)
RPROMPT=$(git_info)
