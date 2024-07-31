export PATH=$PATH:/Users/emurphy/Library/Python/3.8/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore dist --ignore .aws-sam --ignore coverage -g ""'
export BAT_THEME='TwoDark'
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export BUILDKIT_PROGRESS=plain

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PYENV_VERSION='3.11.4'

# node-gyp
export CXXFLAGS="-stdlib=libc++"

# pdfme
export LDFLAGS="-L/opt/homebrew/opt/jpeg/lib"
export CPPFLAGS="-I/opt/homebrew/opt/jpeg/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/jpeg/lib/pkgconfig"
