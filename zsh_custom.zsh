# ══════════════════════════════════════════════
#  自定义 ZSH 配置 — 由 nvim 仓库管理
#  在 ~/.zshrc 末尾 source 本文件
# ══════════════════════════════════════════════

unsetopt share_history

# ── 自动进入 tmux（SSH 会话跳过，避免嵌套）──
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ]; then
  tmux attach || tmux new -s main
fi

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
# Yazi 文件管理器
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
