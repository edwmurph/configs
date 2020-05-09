ignore_dirs=$(cat "${ZSH_CUSTOM}/plugins/aliases/ignore_dirs.txt" \
  | tr '\n' ' ' \
  | tr -s ' ' \
  | sed -e "s/[[:space:]]/|/g" \
  | sed -e "s/^|\(.*\)|$/\1/g" \
  | sed -e "s/|$//"
)

# navigation
  alias pcf='goto ~/code/personal/configs'
  alias pem='goto ~/code/personal/emurphy'
  alias pgb='goto ~/code/personal/gatsbyjs'
  alias pds='goto ~/code/personal/ds'
  alias ptf='goto ~/code/personal/tensorflow'
  alias pus='goto ~/code/personal/uss'
  alias pte='goto ~/code/personal/temp'
  alias pbn='goto ~/code/personal/bitnado.io'
  alias pbf='goto ~/code/personal/bitforge'
  alias pjm='goto ~/code/personal/jormungandr'
  alias ptjsr='goto ~/code/personal/threejsr'

  alias co='goto ~/code'
  alias se='goto ~/.secrets'

  alias personal='cd ~/Library/"Mobile Documents"/com~apple~CloudDocs/PERSONAL && echo -ne "\033]0;"~/...PERSONAL"\007"'
  alias documents='cd ~/Library/"Mobile Documents"/com~apple~CloudDocs/Documents && echo -ne "\033]0;"~/...Documents"\007"'


# native commands
  alias e="exit"
  alias tt="tree -a -L 10 -C -I '$ignore_dirs'"
  alias ttt="tree -a -L 10 -C -I '$ignore_dirs|test'"
  alias agq="ag --hidden --ignore=.git -Q"
  alias agqt="ag --hidden --ignore=test --ignore=.git -Q"

# git
  alias grr="git reset HEAD~1"
  alias gdm="git diff master -- . ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
  alias gdsm="git diff --staged master -- . ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
  alias gdst="git diff HEAD --stat"
  alias gbdaa="git branch --no-color | command grep -vE '^(\+|\*|\s*(master|develop|dev)\s*$)' | command xargs -n 1 git branch -D"
  alias gd="git diff ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
  alias gds="git diff --staged ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
  alias gdd="git diff HEAD^ -- ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock'"
  alias gpod="git push origin --delete"

# npm
  alias nrm="npm run mocha"
  alias nrtf="npm run test:functional"
  alias ns="npm start"
  alias nt="npm test"
  alias nrd="npm run dev"
  alias nrs="npm run serve"
  alias nrbd="npm run build-dev"
  alias nrk="npm run kill"
  alias nrkd="npm run kill-dev"
  alias nrw="npm run watch"
  alias nrc="npm run clean"
  alias nrb="npm run build"
  alias nrl="npm run lint"
  alias nrwi="NODE_ENV=integration npm run watch"
  alias ncu="npx npm-check --skip-unused"

# python
  alias serve="python -m SimpleHTTPServer"
  alias nb="jupyter notebook"

# other apps
  alias ld="node ${ZSH_CUSTOM}/plugins/aliases/local-date.js"
  alias tf='terraform'
  alias nm='node --experimental-modules --experimental-json-modules --es-module-specifier-resolution=node'
  alias md='macdown'
  alias kc='kubectl'
  alias ngrok_url='curl -s localhost:4040/api/tunnels | jq -r ".tunnels[0].public_url"'
  alias ang='ngrok_url | alert'

# secrets
  source "${SECRETS}/secrets.zsh"
  alias jor="ssh bitforge@$JORMUNGANDR_IP"
  unset_secrets
