# ══════════════════════════════════════════════
#              Costom ZSH config
#
#  Source this file at the end of your ~/.zshrc
# ══════════════════════════════════════════════

typeset -U path
for _p in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/.fzf/bin"; do
  [ -d "$_p" ] && path=("$_p" $path)
done
unset _p

export EDITOR='nvim'
export VISUAL='nvim'
alias vi='nvim'
alias vim='nvim'

unsetopt share_history

if command -v eza &>/dev/null; then
  alias ll='eza -lF'
  alias la='eza -a'
  alias l='eza'
elif command -v exa &>/dev/null; then
  alias ll='exa -lF'
  alias la='exa -a'
  alias l='exa'
fi

#  Session restore with nvim
function vis() {
  if [ -f Session.vim ]; then
    nvim -S Session.vim "$@"
  else
    nvim "$@"
  fi
}

# Tmux alias attach/new
function t() {
  local session="${1:-main}"
  if [ -n "$TMUX" ]; then
    tmux has-session -t "$session" 2>/dev/null || tmux new-session -d -s "$session"
    tmux switch-client -t "$session"
  else
    tmux new-session -A -s "$session"
  fi
}

# Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# LazyGit
function lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# fzf — Ctrl-R 历史 / Ctrl-T 文件 / Alt-C 目录
if command -v fzf >/dev/null 2>&1; then
  _fd=
  if [[ -n ${commands[fd]} ]]; then _fd=fd
  elif [[ -n ${commands[fdfind]} ]]; then _fd=fdfind
  fi
  if [[ -n $_fd ]]; then
    export FZF_DEFAULT_COMMAND="$_fd --type f --hidden --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$_fd --type d --hidden --exclude .git"
  fi
  unset _fd
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
  if _fzf_init=$(fzf --zsh 2>/dev/null); then
    eval "$_fzf_init" 2>/dev/null
  elif [ -d "$HOME/.fzf/shell" ]; then
    source "$HOME/.fzf/shell/completion.zsh"   2>/dev/null
    source "$HOME/.fzf/shell/key-bindings.zsh" 2>/dev/null
  fi
  unset _fzf_init
fi

