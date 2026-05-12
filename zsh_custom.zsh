# ══════════════════════════════════════════════
#  自定义 ZSH 配置 — 由 nvim 仓库管理
#  在 ~/.zshrc 末尾 source 本文件
# ══════════════════════════════════════════════

# PATH：把 install.sh 安装的用户级目录加进来（typeset -U 去重，目录存在才加）
typeset -U path
for _p in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/go/bin"; do
  [ -d "$_p" ] && path=("$_p" $path)
done
unset _p

export EDITOR='nvim'
export VISUAL='nvim'
alias vi='nvim'
alias vim='nvim'

unsetopt share_history

# ── 别名 ────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ll='eza -lF'
  alias la='eza -a'
  alias l='eza'
elif command -v exa &>/dev/null; then
  alias ll='exa -lF'
  alias la='exa -a'
  alias l='exa'
fi

# ── 工具函数 ────────────────────────────────
# tmux 快速进入
function t() {
  if [ -n "$TMUX" ]; then
    echo "Already inside tmux."
    return 1
  fi
  local session="${1:-main}"
  tmux attach -t "$session" 2>/dev/null || tmux new -s "$session"
}

# Yazi 文件管理器
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# ── zsh 插件 ────────────────────────────────
# 放在最后：语法高亮要求在所有 zle 小部件注册之后 source
_zsh_syntax_hl="$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$_zsh_syntax_hl" ] && source "$_zsh_syntax_hl"
unset _zsh_syntax_hl

