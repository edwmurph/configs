#!/bin/bash

# TODO make expected location of this configs repo configurable

# To use this .bash_profile, symlink this file to your home directory:
# ln -s ${HOME}/code/configs/.bash_profile ${HOME}/.bash_profile

. ~/code/configs/.bash_profile_helpers

source_if_exists ~/.secrets/secrets.sh
source_if_exists ~/.secrets/env.sh
source_if_exists ~/code/configs/.bash_profile_cisco
source_if_exists ~/code/configs/.bash_profile_prompt
source_if_exists ~/code/configs/.bash_profile_node
source_if_exists ~/code/configs/git-completion.bash


### TERMINAL CONFIGS


if [ brew -v 2>/dev/null ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# change name of title bar to the directory path in which new sessions are initiated
echo -ne "\033]0;"$(pwd | sed "s/^$(echo $HOME | sed 's/\//\\\//g')/~/g")"\007"

# change color of title bar to black
printf -- $'\033]6;1;bg;red;brightness;20\a\033]6;1;bg;green;brightness;20\a\033]6;1;bg;blue;brightness;20\a'


### ALIASES


# native shortcuts
  # use ctags from brew to enable the -R flag
  alias ctags="`brew --prefix`/bin/ctags"
  alias tag='ctags -R . --exclude=target --exclude=vendor'
  alias ls='ls -G'
  alias ll='ls -a'
  alias tt="tree -C -I 'node_modules|ui|coverage|target'"
  alias e="exit"

# git
  alias gs='git status'
  alias gp='git pull'
  alias gl="git log --pretty=format:'%C(yellow)%h|%Cred%ad|%Cblue%an|%Cgreen%d %Creset%s' --date=format:'%Y-%m-%d %H:%M:%S'"
  alias gcm="git checkout master"
  alias gc.="git checkout ."
  alias gc="git checkout"
  alias gb="git branch -vv"
  alias gbdl="git branch | grep -v master | xargs git branch -D"
  alias grr="git reset HEAD~1"
  alias gct="git commit -m 'temp commit'"
  alias gdm="git diff master -- . ':(exclude)package-lock.json'"
  alias rmlocks="find . -maxdepth 2 -name package-lock.json -exec rm {} \;"

# navigation
  alias co='cd ~/code/configs && echo -ne "\033]0;"~/code/configs"\007"'
  alias sc='cd ~/code/scala && echo -ne "\033]0;"~/code/scala"\007"'
  alias se='cd ~/.secrets && echo -ne "\033]0;"~/code/configs"\007"'
  alias nv='cd ~/.nvm && echo -ne "\033]0;"~/.nvm"\007"'

# npm
  alias nrtf="npm run test:functional"
  alias ns="npm start"
  alias nlrt="npx lerna run test"


# python
  alias serve="python -m SimpleHTTPServer"

# ssh
  alias celeryL="ssh edwmurph@${CELERY_IP}"
  alias celeryR="ssh edwmurph@${ROUTER_IP}"


# FUNCTIONS


function s() {
  file=${1?file path is requied}
  if [ -n "$file" ]; then
    scala -nc "$file"
  fi
}

function v() {
  file="$(fzf)"
  if [ -n "$file" ]; then
    vim "$file"
  fi
}

# Connect to VC's vpn through anyconnect
function vpnVC() {
  # launchctl load /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist 2> /dev/null
  printf "CustomerVPN\nbitforge1\n${BFVPN_PW}\n" |
    /opt/cisco/anyconnect/bin/vpn -s connect 'dc4-vpn.purepacket.com'
}

# Disconnect from anyconnect vpn
function vpnD() {
  /opt/cisco/anyconnect/bin/vpn -s disconnect
  # launchctl unload /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist 2> /dev/null
}

function bsp() {
  old='2.7.13'
  new='3.6.4_3'
  pythonVersion="$(/usr/local/bin/python --version | cut -d ' ' -f2)"
  if [[ $new =~ $pythonVersion ]]; then
    brew switch python $old
  else
    brew switch python $new
  fi
}

# Find and replace all strings in files (up to 2 directories deep) matching regex relative to current directory
# E.g. `far package.json '"node": "8.11.4"' '"node": "8.11.5"'`
function far() {
	filename=${1?Expects filename as 1st parameter}
	regexpToFind=${2?Expects regexp to search for as 2nd parameter}
	replacementStr=${3?Expects string to replace matched regexps with as 3rd parameter}
	find . -name ${filename} -maxdepth 2 -exec sed -i '' -e "s/${regexpToFind}/${replacementStr}/g" {} \;
}

function Hist() {
  git log --pretty=format:"%C(yellow)>>>|%h|%Cred%ad|%Cblue%an|%Creset%s" --date=format:"%Y-%m-%d %H:%M" -p ${1?must pass a file location for first arg} | sed -e '/>>>|/{n;N;N;N;d;}' | sed -e 's/\(^-.*$\)/'$(printf "\033[91m")'\1'$(printf "\033[0m")'/g' | sed -e 's/\(^+.*$\)/'$(printf "\033[92m")'\1'$(printf "\033[0m")'/g'
}

function p() {
  python "${1?Error trying to execute a python script without a file}"
}

function agq() {
  ag --hidden -Q "$1" -G ${2-.} -i --ignore=node_modules --ignore=coverage --ignore=package-lock.json --ignore=dashboards
}

function agqq() {
  ag --hidden -Q "$1" -G ${2-.} -i --ignore=coverage --ignore=package-lock.json --ignore=dashboards
}

function gd() {
  git diff "${2-HEAD}" -- "${1-.}" ':(exclude)*package-lock.json'
}

function gdd() {
  git diff HEAD^ -- "${1-.}" ':(exclude)*package-lock.json'
}

function grho() {
  git reset --hard origin/"$1"
}

function dif() {
  git diff --no-index -- "${1?Must provide 1st arg that points to a file}" "${2-Must provide 2nd arg that points to a file}"
}

function kc() {
  sudo kubectl "$@"
}

function gfc() {
  # TODO add logic to make this detect error of not being on local network and automatically try using the rourter's IP
  path_on_remote="${1?arg1 missing: path to file on Celery}"
  local_destination_path="${2?arg2 missing: path to where to transfer file to on local machine}"
  scp "edwmurph@${CELERY_IP}:${path_on_remote}" "${local_destination_path}"
}


### BAT


export BAT_THEME=TwoDark


### PYTHON


PATH="${HOME}/anaconda/bin:$PATH"


### GO


GOPATH="$HOME/go"
PATH="$PATH:$GOPATH/bin"


### FZF


export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
