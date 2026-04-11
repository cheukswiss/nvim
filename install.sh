#!/usr/bin/env bash
# ══════════════════════════════════════════════
#  dotfiles 交互式安装脚本
#  用法:
#    bash install.sh          # 交互模式
#    bash install.sh --all    # 全部安装
#    bash install.sh tmux zsh # 指定模块
# ══════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSHRC="$HOME/.zshrc"
TMUX_CONF="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ── 平台检测 ────────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
  PLATFORM="macOS"
  PKG_CMD=(brew install)
  # macOS 自带 pbcopy，不需要 xclip
  DEPS=(tmux eza yazi)
else
  PLATFORM="Linux"
  PKG_CMD=(sudo apt install -y)
  DEPS=(tmux xclip eza yazi)
fi

LINTERS=(shellcheck ruff golangci-lint cppcheck)
NPM_LINTERS=(eslint_d)

# ── 颜色与输出 ──────────────────────────────
GREEN='\033[32m'  YELLOW='\033[33m'  CYAN='\033[36m'
RED='\033[31m'    BOLD='\033[1m'     RESET='\033[0m'

info()  { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET} $1"; }
skip()  { echo -e "${CYAN}[SKIP]${RESET} $1"; }
err()   { echo -e "${RED}[ERR]${RESET} $1"; }

# ── 状态检测函数 ────────────────────────────

deps_status() {
  local installed=0 total=${#DEPS[@]} missing_list=()
  for cmd in "${DEPS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      ((installed++))
    else
      missing_list+=("$cmd")
    fi
  done
  if (( installed == total )); then
    echo "done"
  elif (( installed == 0 )); then
    echo "none|${missing_list[*]}"
  else
    echo "partial|$installed/$total|${missing_list[*]}"
  fi
}

tmux_status() {
  local ok=0 total=2
  # 检查 symlink
  if [ -L "$TMUX_CONF" ] && [ "$(readlink "$TMUX_CONF")" = "$SCRIPT_DIR/tmux.conf" ]; then
    ((ok++))
  fi
  # 检查 TPM
  if [ -d "$TPM_DIR" ]; then
    ((ok++))
  fi
  if (( ok == total )); then echo "done"
  elif (( ok == 0 )); then echo "none"
  else echo "partial|$ok/$total"
  fi
}

zsh_status() {
  local ok=0 total=2
  # 检查 source line
  if [ -f "$ZSHRC" ] && grep -qF "zsh_custom.zsh" "$ZSHRC"; then
    ((ok++))
  fi
  # 检查 zsh-syntax-highlighting
  if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    ((ok++))
  fi
  if (( ok == total )); then echo "done"
  elif (( ok == 0 )); then echo "none"
  else echo "partial|$ok/$total"
  fi
}

linters_status() {
  local installed=0 total=$(( ${#LINTERS[@]} + ${#NPM_LINTERS[@]} )) missing_list=()
  for cmd in "${LINTERS[@]}" "${NPM_LINTERS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      ((installed++))
    else
      missing_list+=("$cmd")
    fi
  done
  if (( installed == total )); then
    echo "done"
  elif (( installed == 0 )); then
    echo "none|${missing_list[*]}"
  else
    echo "partial|$installed/$total|${missing_list[*]}"
  fi
}

# ── 格式化状态显示 ──────────────────────────

format_status() {
  local label="$1" status="$2"
  local state="${status%%|*}"
  case "$state" in
    done)
      printf "  ${GREEN}✓${RESET} %-14s ${GREEN}已配置${RESET}\n" "$label"
      ;;
    none)
      if [[ "$status" == *"|"* ]]; then
        local missing="${status#*|}"
        printf "  ${RED}✗${RESET} %-14s ${RED}未安装${RESET} (缺少: ${missing})\n" "$label"
      else
        printf "  ${RED}✗${RESET} %-14s ${RED}未配置${RESET}\n" "$label"
      fi
      ;;
    partial)
      local rest="${status#*|}"
      local count="${rest%%|*}"
      local missing="${rest#*|}"
      printf "  ${YELLOW}●${RESET} %-14s ${YELLOW}${count} 已安装${RESET} (缺少: ${missing})\n" "$label"
      ;;
  esac
}

# ── 安装函数 ────────────────────────────────

install_deps() {
  echo ""
  echo -e "${BOLD}── 安装系统依赖 ──${RESET}"
  local missing=()
  for cmd in "${DEPS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      skip "$cmd 已安装"
    else
      missing+=("$cmd")
    fi
  done
  if [ ${#missing[@]} -eq 0 ]; then
    info "所有依赖已就绪"
    return
  fi
  echo ""
  echo -e "将执行: ${CYAN}${PKG_CMD[*]} ${missing[*]}${RESET}"
  if [[ "${AUTO_INSTALL:-}" != "1" ]]; then
    read -rp "确认安装？[Y/n] " ans
    [[ "$ans" =~ ^[Nn]$ ]] && { skip "跳过依赖安装"; return; }
  fi
  "${PKG_CMD[@]}" "${missing[@]}" && info "依赖安装完成" || err "部分依赖安装失败"
}

install_tmux() {
  echo ""
  echo -e "${BOLD}── 配置 tmux ──${RESET}"

  # symlink
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

  # TPM
  if [ -d "$TPM_DIR" ]; then
    skip "TPM 已安装"
  else
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    info "TPM 已安装，启动 tmux 后按 Alt-b I 安装插件"
  fi
}

install_zsh() {
  echo ""
  echo -e "${BOLD}── 配置 zsh ──${RESET}"

  # source line
  local SOURCE_LINE='[ -f "$HOME/.config/nvim/zsh_custom.zsh" ] && source "$HOME/.config/nvim/zsh_custom.zsh"'
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

  # oh-my-zsh 插件
  if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    skip "zsh-syntax-highlighting 已安装"
  else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    info "zsh-syntax-highlighting 已安装"
  fi
}

install_linters() {
  echo ""
  echo -e "${BOLD}── 安装开发工具 (Linters) ──${RESET}"

  # brew/apt linters
  local pkg_missing=()
  for cmd in "${LINTERS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      skip "$cmd 已安装"
    else
      pkg_missing+=("$cmd")
    fi
  done
  if [ ${#pkg_missing[@]} -gt 0 ]; then
    echo ""
    echo -e "将执行: ${CYAN}${PKG_CMD[*]} ${pkg_missing[*]}${RESET}"
    if [[ "${AUTO_INSTALL:-}" != "1" ]]; then
      read -rp "确认安装？[Y/n] " ans
      [[ "$ans" =~ ^[Nn]$ ]] && { skip "跳过 brew/apt linters"; pkg_missing=(); }
    fi
    if [ ${#pkg_missing[@]} -gt 0 ]; then
      "${PKG_CMD[@]}" "${pkg_missing[@]}" && info "Linters 安装完成" || err "部分 linters 安装失败"
    fi
  fi

  # npm linters
  local npm_missing=()
  for cmd in "${NPM_LINTERS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      skip "$cmd 已安装"
    else
      npm_missing+=("$cmd")
    fi
  done
  if [ ${#npm_missing[@]} -gt 0 ]; then
    if ! command -v npm &>/dev/null; then
      warn "npm 未安装，跳过 ${npm_missing[*]}"
      return
    fi
    echo -e "将执行: ${CYAN}npm install -g ${npm_missing[*]}${RESET}"
    if [[ "${AUTO_INSTALL:-}" != "1" ]]; then
      read -rp "确认安装？[Y/n] " ans
      [[ "$ans" =~ ^[Nn]$ ]] && { skip "跳过 npm linters"; return; }
    fi
    npm install -g "${npm_missing[@]}" && info "npm linters 安装完成" || err "npm linters 安装失败"
  fi
}

# ── 交互菜单 ────────────────────────────────

show_menu() {
  echo ""
  echo -e "${BOLD}══════════════════════════════════════${RESET}"
  echo -e "${BOLD}  dotfiles 安装脚本${RESET}"
  echo -e "${BOLD}══════════════════════════════════════${RESET}"
  echo -e "  平台: ${CYAN}${PLATFORM}${RESET}"
  echo ""

  local ds ts zs ls
  ds=$(deps_status)
  ts=$(tmux_status)
  zs=$(zsh_status)
  ls=$(linters_status)

  printf "  ${BOLD}[1]${RESET} "; format_status "系统依赖" "$ds"
  printf "  ${BOLD}[2]${RESET} "; format_status "tmux 配置" "$ts"
  printf "  ${BOLD}[3]${RESET} "; format_status "zsh 配置" "$zs"
  printf "  ${BOLD}[4]${RESET} "; format_status "开发工具" "$ls"
  echo ""
  echo -e "  ${BOLD}[a]${RESET} 全部安装  ${BOLD}[q]${RESET} 退出"
  echo ""
  read -rp "请选择 (可多选，如 1 3 4): " choices

  for choice in $choices; do
    case "$choice" in
      1) install_deps ;;
      2) install_tmux ;;
      3) install_zsh ;;
      4) install_linters ;;
      a) install_deps; install_tmux; install_zsh; install_linters ;;
      q) echo "退出"; exit 0 ;;
      *) warn "未知选项: $choice" ;;
    esac
  done
}

# ── 主入口 ──────────────────────────────────

main() {
  if [[ $# -eq 0 ]]; then
    show_menu
  else
    for arg in "$@"; do
      case "$arg" in
        --all)   AUTO_INSTALL=1; install_deps; install_tmux; install_zsh; install_linters ;;
        --help)  echo "用法: bash install.sh [--all | --help | deps tmux zsh linters]"; exit 0 ;;
        deps)    install_deps ;;
        tmux)    install_tmux ;;
        zsh)     install_zsh ;;
        linters) install_linters ;;
        *)       err "未知参数: $arg"; exit 1 ;;
      esac
    done
  fi

  echo ""
  echo -e "${BOLD}══════════════════════════════════════${RESET}"
  echo -e "${BOLD}  安装完成！${RESET}"
  echo -e "${BOLD}══════════════════════════════════════${RESET}"
  echo "  重启终端或执行 source ~/.zshrc 生效"
  echo ""
}

main "$@"
