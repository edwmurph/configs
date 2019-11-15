ignore_dirs=$(echo '
.env node_modules ui coverage target .git .nyc_output *.swp .cache dist
bootstrap-sass material-dashboard .ipynb_checkpoints __pycache__ public build
.DS_Store jsm
' \
  | tr '\n' ' ' \
  | tr -s ' ' \
  | sed -e "s/[[:space:]]/|/g" \
  | sed -e "s/^|\(.*\)|$/\1/g" \
)

# navigation
  alias pte='goto ~/code/personal/tess'
  alias pcf='goto ~/code/personal/configs'
  alias pem='goto ~/code/personal/emurphy'
  alias pgb='goto ~/code/personal/gatsbyjs'
  alias pds='goto ~/code/personal/ds'
  alias ptf='goto ~/code/personal/tensorflow'
  alias pus='goto ~/code/personal/uss'
  alias pte='goto ~/code/personal/temp'
  alias pbn='goto ~/code/personal/bitnado'
  alias pcp='goto ~/code/personal/crypto-predict'
  alias pce='goto ~/code/personal/cardano-explorer'

  alias co='goto ~/code'
  alias se='goto ~/.secrets'

  alias personal='cd ~/Library/"Mobile Documents"/com~apple~CloudDocs/PERSONAL && echo -ne "\033]0;"~/...PERSONAL"\007"'
  alias documents='cd ~/Library/"Mobile Documents"/com~apple~CloudDocs/Documents && echo -ne "\033]0;"~/...Documents"\007"'


# native commands
  alias e="exit"
  alias tt="tree -a -L 10 -C -I '$ignore_dirs'"
  alias ttt="tree -a -L 10 -C -I '$ignore_dirs|test'"
  alias agq="ag --hidden -Q"
  alias agqt="ag --hidden --ignore=test -Q"

# git
  alias grr="git reset HEAD~1"
  alias gdm="git diff master -- . ':(exclude)package-lock.json'"
  alias gdst="git diff HEAD --stat"
  alias gbdaa="git branch --no-color | command grep -vE '^(\+|\*|\s*(master|develop|dev)\s*$)' | command xargs -n 1 git branch -D"

# npm
  alias nrtf="npm run test:functional"
  alias ns="npm start"
  alias nt="npm test"
  alias nrd="npm run dev"
  alias nrk="npm run kill"
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
  alias md='macdown'
