# ══════════════════════════════════════════════
#        ZSH pre-OMZ config（OMZ 加载前）
#
#  Source this BEFORE `source $ZSH/oh-my-zsh.sh`
# ══════════════════════════════════════════════

typeset -gU plugins

plugins+=(
  git
  z
  extract
  colored-man-pages
  zsh-syntax-highlighting
  history-substring-search
)
