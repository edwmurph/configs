#!/bin/bash

# TODO make expected location of this configs repo configurable

# To use this .bash_profile, symlink this file to your home directory:
# ln -s ${HOME}/code/configs/.bash_profile ${HOME}/.bash_profile

. ~/code/configs/.bash_profile_helpers

sourceIfExists ~/.secrets/.secrets
sourceIfExists ~/.env
sourceIfExists ~/code/configs/.bash_profile_cisco
sourceIfExists ~/code/configs/.git-prompt.sh
sourceIfExists ~/code/configs/.bash_profile_timer


### NODE

NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Automatically switch to node version specified in local dir's package.json (don't do this when in node_modules)
function autoswitch_to_node_version() {
  if [ -f 'package.json' ] && [[ "$PWD" != *'node_modules'* ]]; then
    requested_node_version="v$(node -p "require('./package.json').engines.node")"
    current_node_version="$(nvm current)"
    if [ "$requested_node_version" != "$current_node_version" ]; then
      # printf "requested_node_version: $requested_node_version\ncurrent_node_version: $current_node_version\n"
      nvm use
    fi
  fi
}
cd () { builtin cd "$@" && autoswitch_to_node_version; }
pushd () { builtin pushd "$@" && autoswitch_to_node_version; }
popd () { builtin popd "$@" && autoswitch_to_node_version; }
cd .

[[ "$PATH" == *"./node_modules/.bin"* ]] || PATH="$PATH:./node_modules/.bin"


### TERMINAL CONFIGS

if [ brew -v 2>/dev/null ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# change name of title bar to the directory path in which new sessions are initiated
echo -ne "\033]0;"$(pwd | sed "s/^$(echo $HOME | sed 's/\//\\\//g')/~/g")"\007"

# change color of title bar to black
printf -- $'\033]6;1;bg;red;brightness;20\a\033]6;1;bg;green;brightness;20\a\033]6;1;bg;blue;brightness;20\a'


### BAT

export BAT_THEME=TwoDark


### PYTHON

PATH="${HOME}/anaconda/bin:$PATH"


### GO

GOPATH="$HOME/go"
PATH="$PATH:$GOPATH/bin"


### Aliases

alias ls='ls -G'
alias ll='ls -a'
alias gs='git status'
alias gp='git pull'
alias gl="git log --pretty=format:'%C(yellow)%h|%Cred%ad|%Cblue%an|%Cgreen%d %Creset%s' --date=format:'%Y-%m-%d %H:%M:%S'"
alias gcm="git checkout master"
alias gc.="git checkout ."
alias gc="git checkout"
alias gb="git branch -vv"
alias gbdl="git branch | grep -v master | xargs git branch -D"
alias co='cd ~/code/configs && echo -ne "\033]0;"~/code/configs"\007"'
alias nv='cd ~/.nvm && echo -ne "\033]0;"~/.nvm"\007"'
alias tt="tree -C -I 'node_modules|ui|coverage'"
alias e="exit"
alias ss="pmset displaysleepnow"
alias serve="python -m SimpleHTTPServer"
alias rmlocks="find . -maxdepth 2 -name package-lock.json -exec rm {} \;"
alias rr="rm package-lock.json && rm -rf node_modules"
alias nlrt="npx lerna run test"
alias nrtf="npm run test:functional"
alias ns="npm start"
alias grr="git reset HEAD~1"
alias gct="git commit -m 'temp commit'"
alias gdm="git diff master -- . ':(exclude)package-lock.json'"
alias celeryL="ssh edwmurph@${CELERY_IP}"
alias celeryR="ssh edwmurph@${ROUTER_IP}"

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
  ag -Q "$1" -G ${2-.} -i --ignore=node_modules --ignore=coverage --ignore=package-lock.json --ignore=dashboards
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
  kubectl "$@"
}

