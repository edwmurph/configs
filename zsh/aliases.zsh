# general
alias e="exit"
alias vim="nvim"
alias kc="kubectl"
alias nr="npm run"
alias nrl="npm run lint"
alias nrm="npm run mocha"
alias agq="ag --hidden --ignore=package-lock.json -Q -p $CONFIGS_PATH/zsh/ignore-dirs.ignore"
alias zp='open -a "Google Chrome" "https://zoom.us/j/5597640531?pwd=bk5MYW5MSVBlMXJZbDBQQWtGRlJ3UT09"'
alias zh='open -a "Google Chrome" "https://hubspot.zoom.us/j/7972299201?pwd=UU5KTC9aaWVBOUxtQ25jSVNxTFpoQT09"'
alias nd='NODE_DEBUG=info node'
alias dun='du -h node_modules | sort -h | tail -20'
alias todo='vim ~/.secrets/todo.md'


# git
alias gcd="git checkout develop"
alias gbD="git branch -D"
alias gb="git branch"
alias grbc="git rebase --continue"
alias glo="git log --pretty=format:'%Cred%h%Creset %Cgreen(%cr) %C(bold blue)<%an>%C(auto)%d%Creset %s%+b' --abbrev-commit"
alias gl="git pull"
alias gcb="git checkout -b"
alias gco="git checkout"
alias gst="git status"
alias gaa="git add -A"
alias gcmsg="git commit -m"
alias gclean="git clean -fd"
alias gclean_branches="git gc --prune=now && git remote prune origin"
alias grr="git reset HEAD~1"
alias gdm="git diff master -- . ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
alias gdsm="git diff --staged master -- . ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
alias gdst="git diff HEAD --stat"
alias gbdaa="git branch --no-color | command grep -vE '^(\+|\*|\s*(master|develop|dev)\s*$)' | command xargs -n 1 git branch -D"
alias gp="git push"
alias gd="git diff ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
alias gds="git diff --staged ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
alias gdd="git diff HEAD^ -- ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
alias gpod="git push origin --delete"
alias gcm="git checkout main 2>/dev/null || git checkout master 2>/dev/null || echo 'no main or master branch found'"
alias gbda="git branch | grep -v main | xargs git branch -d"
alias gbDa="git branch | grep -v main | xargs git branch -D"

# navigation
alias se="goto ~/.secrets"
alias pem="goto ~/code/personal/edwardmurphy.dev"
alias ppsa="goto ~/code/personal/personal"
alias pcf="goto ~/code/personal/configs"
alias cc="goto ~/code/claim-clock/claim-clock"
