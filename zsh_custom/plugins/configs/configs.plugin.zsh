export BAT_THEME=TwoDark

# enables ignoring .gitignore globs in fuzzy search
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'


# custom zsh-syntax-highlighting styles
typeset -A ZSH_HIGHLIGHT_STYLES
export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
