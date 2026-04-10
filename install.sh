#!/usr/bin/env bash
# ══════════════════════════════════════════════
#  dotfiles 安装脚本
#  用法: bash ~/.config/nvim/install.sh
# ══════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSHRC="$HOME/.zshrc"
TMUX_CONF="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"

info()  { echo -e "\033[32m[OK]\033[0m $1"; }
warn()  { echo -e "\033[33m[WARN]\033[0m $1"; }
skip()  { echo -e "\033[36m[SKIP]\033[0m $1"; }

# ── 检查依赖 ────────────────────────────────
echo "检查依赖..."
deps=(tmux xclip exa yazi)
missing=()
for cmd in "${deps[@]}"; do
  if command -v "$cmd" &>/dev/null; then
    info "$cmd 已安装"
  else
    warn "$cmd 未安装"
    missing+=("$cmd")
  fi
done

if [ ${#missing[@]} -gt 0 ]; then
  echo ""
  warn "缺少以下工具: ${missing[*]}"
  echo "  建议安装: sudo apt install ${missing[*]}"
  echo ""
fi

# ── tmux.conf 符号链接 ──────────────────────
echo ""
echo "配置 tmux..."
if [ -L "$TMUX_CONF" ] && [ "$(readlink "$TMUX_CONF")" = "$SCRIPT_DIR/tmux.conf" ]; then
  skip "tmux.conf 符号链接已存在"
elif [ -e "$TMUX_CONF" ]; then
  mv "$TMUX_CONF" "$TMUX_CONF.bak"
  ln -s "$SCRIPT_DIR/tmux.conf" "$TMUX_CONF"
  info "tmux.conf 已备份为 .tmux.conf.bak 并创建符号链接"
else
  ln -s "$SCRIPT_DIR/tmux.conf" "$TMUX_CONF"
  info "tmux.conf 符号链接已创建"
fi

# ── zshrc 追加 source ───────────────────────
echo ""
echo "配置 zsh..."
SOURCE_LINE='[ -f "$HOME/.config/nvim/zsh_custom.zsh" ] && source "$HOME/.config/nvim/zsh_custom.zsh"'

if [ -f "$ZSHRC" ] && grep -qF "zsh_custom.zsh" "$ZSHRC"; then
  skip "zshrc 中已包含 zsh_custom.zsh"
elif [ -f "$ZSHRC" ]; then
  echo "" >> "$ZSHRC"
  echo "# 加载自定义配置（由 nvim 仓库管理）" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  info "已追加 source 到 zshrc"
else
  warn "未找到 ~/.zshrc，请手动添加: $SOURCE_LINE"
fi

# ── oh-my-zsh 插件 ──────────────────────────
echo ""
echo "配置 oh-my-zsh 插件..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# colored-man-pages（oh-my-zsh 内置，仅检查）
if [ -d "$HOME/.oh-my-zsh/plugins/colored-man-pages" ]; then
  skip "colored-man-pages 已存在（内置插件）"
else
  warn "colored-man-pages 未找到，请确认 oh-my-zsh 已安装"
fi

# zsh-syntax-highlighting（外部插件，需 clone）
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  skip "zsh-syntax-highlighting 已安装"
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  info "zsh-syntax-highlighting 已安装"
fi

# ── 安装 TPM ────────────────────────────────
echo ""
echo "配置 TPM..."
if [ -d "$TPM_DIR" ]; then
  skip "TPM 已安装"
else
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  info "TPM 已安装，启动 tmux 后按 Alt-b I 安装插件"
fi

# ── 完成 ────────────────────────────────────
echo ""
echo "══════════════════════════════════════"
echo "  安装完成！"
echo "══════════════════════════════════════"
if [ ${#missing[@]} -gt 0 ]; then
  echo "  待安装: ${missing[*]}"
fi
echo "  重启终端或执行 source ~/.zshrc 生效"
echo ""
