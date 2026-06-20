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
# 独立目录，不强依赖 oh-my-zsh；zsh_custom.zsh 会 source 这里的插件
ZSH_PLUGIN_DIR="$HOME/.zsh/plugins"

# ── 平台检测 ────────────────────────────────
# DEPS 条目格式: "<包名> <命令名>"（ripgrep/fd 的包名与二进制名不一致）
# ripgrep/fd 是 telescope live_grep / find_files 的运行时依赖
if [[ "$(uname)" == "Darwin" ]]; then
  PLATFORM="macOS"
  PKG_CMD=(brew install)
  DEPS=("tmux tmux" "ripgrep rg" "fd fd")
else
  PLATFORM="Linux"
  PKG_CMD=(sudo apt install -y)
  DEPS=("tmux tmux" "xclip xclip" "ripgrep rg" "fd-find fdfind fd")
fi

CARGO_DEPS=(eza yazi)
GO_DEPS=("glow github.com/charmbracelet/glow@latest")
# nvim-treesitter main 分支用 `tree-sitter build` 编译 parser，必须装 CLI
NPM_DEPS=("tree-sitter-cli tree-sitter")
LINTERS=(shellcheck cppcheck)
CUSTOM_LINTERS=(golangci-lint ruff)
NPM_LINTERS=(eslint_d)

# ── 颜色与输出 ──────────────────────────────
GREEN='\033[32m'  YELLOW='\033[33m'  CYAN='\033[36m'
RED='\033[31m'    BOLD='\033[1m'     RESET='\033[0m'

info()  { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET} $1"; }
skip()  { echo -e "${CYAN}[SKIP]${RESET} $1"; }
err()   { echo -e "${RED}[ERR]${RESET} $1"; }

# ── 状态检测函数 ────────────────────────────

# dep_bins - 输出 deps 模块全部依赖对应的命令名（每行一个）
# "<包名> <命令名>" 格式条目取命令名；GO_DEPS 取首字段；CARGO_DEPS 即命令名
dep_bins() {
  local entry
  for entry in "${DEPS[@]}" "${NPM_DEPS[@]}"; do echo "${entry##* }"; done
  for entry in "${CARGO_DEPS[@]}"; do echo "$entry"; done
  for entry in "${GO_DEPS[@]}"; do echo "${entry%% *}"; done
}

# cmds_status <cmd...> - 按命令存在性输出 done / none|缺失 / partial|n/m|缺失
cmds_status() {
  local installed=0 total=$# missing_list=() cmd
  for cmd in "$@"; do
    if command -v "$cmd" &>/dev/null; then
      installed=$((installed + 1))
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

deps_status() {
  # shellcheck disable=SC2046  # dep_bins 输出无空格，依赖分词展开
  cmds_status $(dep_bins)
}

linters_status() {
  cmds_status "${LINTERS[@]}" "${CUSTOM_LINTERS[@]}" "${NPM_LINTERS[@]}"
}

tmux_status() {
  local ok=0 total=2
  # 检查 symlink
  if [ -L "$TMUX_CONF" ] && [ "$(readlink "$TMUX_CONF")" = "$SCRIPT_DIR/tmux.conf" ]; then
    ok=$((ok + 1))
  fi
  # 检查 TPM
  if [ -d "$TPM_DIR" ]; then
    ok=$((ok + 1))
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
    ok=$((ok + 1))
  fi
  # 检查 zsh-syntax-highlighting
  if [ -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    ok=$((ok + 1))
  fi
  if (( ok == total )); then echo "done"
  elif (( ok == 0 )); then echo "none"
  else echo "partial|$ok/$total"
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

# ── 通用确认安装 ────────────────────────────
# confirm_install <描述> <命令...>
# 返回值: 0=成功, SKIP_RC=用户跳过, 其余=命令失败的退出码
# 跳过用专用码，避免与命令本身的 exit 1 混淆（否则失败被当跳过静默吞掉）
SKIP_RC=200
confirm_install() {
  local desc="$1"; shift
  echo -e "将执行: ${CYAN}${desc}${RESET}"
  if [[ "${AUTO_INSTALL:-}" != "1" ]]; then
    local ans
    read -rp "确认安装？[Y/n] " ans
    if [[ "$ans" =~ ^[Nn]$ ]]; then
      skip "跳过 $desc"
      return "$SKIP_RC"
    fi
  fi
  "$@"
}

# run_install <描述> <成功消息> <命令...> - 确认后执行并统一报告结果
run_install() {
  local desc="$1" success="$2"; shift 2
  local rc=0
  confirm_install "$desc" "$@" || rc=$?
  if [[ $rc -eq 0 ]]; then
    info "$success"
  elif [[ $rc -ne $SKIP_RC ]]; then  # 跳过时 confirm_install 已输出提示
    err "$desc 失败 (exit $rc)"
  fi
}

# install_pkgs <标签> <pkg...> - 系统包管理器（apt/brew）批量安装
install_pkgs() {
  local label="$1"; shift
  (( $# == 0 )) && return 0
  run_install "${PKG_CMD[*]} $*" "$label 安装完成" "${PKG_CMD[@]}" "$@"
}

# install_npm_global <pkg...> - 批量 npm -g 安装，自动避免系统 prefix 要 sudo
install_npm_global() {
  (( $# == 0 )) && return 0
  if ! command -v npm &>/dev/null; then
    warn "npm 未安装，跳过 $*"
    return
  fi
  local npm_prefix npm_cmd=(npm install -g)
  npm_prefix="$(npm config get prefix 2>/dev/null)"
  if [[ "$npm_prefix" == /usr* && "$(uname)" != "Darwin" ]]; then
    mkdir -p "$HOME/.local"
    npm_cmd=(npm install -g --prefix "$HOME/.local")
  fi
  run_install "${npm_cmd[*]} $*" "npm 包安装完成: $*" "${npm_cmd[@]}" "$@"
}

# ── 安装函数 ────────────────────────────────

install_deps() {
  echo ""
  echo -e "${BOLD}── 安装系统依赖 ──${RESET}"
  local missing=()
  for entry in "${DEPS[@]}"; do
    local pkg="${entry%% *}" bin="${entry##* }"
    if command -v "$bin" &>/dev/null; then
      skip "$bin 已安装"
    else
      missing+=("$pkg")
    fi
  done
  install_pkgs "系统依赖" "${missing[@]}"

  # cargo 依赖（yazi 等不在 apt 仓库的工具）
  for cmd in "${CARGO_DEPS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      skip "$cmd 已安装"
      continue
    fi
    if ! command -v cargo &>/dev/null; then
      warn "cargo 未安装，跳过 $cmd（请先安装 Rust: https://rustup.rs）"
      continue
    fi
    local cargo_pkg=("$cmd")
    [[ "$cmd" == "yazi" ]] && cargo_pkg=(yazi-fm yazi-cli)
    run_install "cargo install --locked ${cargo_pkg[*]}" "$cmd 安装完成" \
      cargo install --locked "${cargo_pkg[@]}"
  done

  # go 依赖（glow 等）
  for entry in "${GO_DEPS[@]}"; do
    local cmd="${entry%% *}" pkg="${entry#* }"
    if command -v "$cmd" &>/dev/null; then
      skip "$cmd 已安装"
      continue
    fi
    if ! command -v go &>/dev/null; then
      warn "go 未安装，跳过 $cmd（请先安装 Go: https://go.dev/dl）"
      continue
    fi
    run_install "go install $pkg" "$cmd 安装完成" go install "$pkg"
  done

  local npm_missing=()
  for entry in "${NPM_DEPS[@]}"; do
    local pkg="${entry%% *}" bin="${entry##* }"
    if command -v "$bin" &>/dev/null; then
      skip "$bin 已安装"
    else
      npm_missing+=("$pkg")
    fi
  done
  install_npm_global "${npm_missing[@]}"
}

install_tmux() {
  echo ""
  echo -e "${BOLD}── 配置 tmux ──${RESET}"

  # symlink
  if [ -L "$TMUX_CONF" ] && [ "$(readlink "$TMUX_CONF")" = "$SCRIPT_DIR/tmux.conf" ]; then
    skip "tmux.conf 符号链接已存在"
  elif [ -e "$TMUX_CONF" ]; then
    local backup
    backup="$TMUX_CONF.bak.$(date +%Y%m%d%H%M%S)"
    mv "$TMUX_CONF" "$backup"
    ln -s "$SCRIPT_DIR/tmux.conf" "$TMUX_CONF"
    info "tmux.conf 已备份为 $backup 并创建符号链接"
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

  # 部署 tmux2k-custom/（官方未提供的插件，如 host）
  local custom_dir="$SCRIPT_DIR/tmux2k-custom"
  local dest_dir="$HOME/.tmux/plugins/tmux2k/plugins"
  if [ -d "$custom_dir" ] && [ -d "$dest_dir" ]; then
    if cp "$custom_dir"/*.sh "$dest_dir/" 2>/dev/null; then
      info "自定义 tmux2k 插件已部署"
    else
      # set -e 下 cp 失败会静默中断脚本，这里显式兜底
      warn "自定义 tmux2k 插件部署失败（检查 $custom_dir/*.sh 是否存在）"
    fi
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

  # zsh 插件（独立目录，由 zsh_custom.zsh 直接 source，不依赖 oh-my-zsh）
  if [ -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    skip "zsh-syntax-highlighting 已安装"
  else
    mkdir -p "$ZSH_PLUGIN_DIR"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
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
  install_pkgs "Linters" "${pkg_missing[@]}"

  # golangci-lint（官方安装脚本）
  if command -v golangci-lint &>/dev/null; then
    skip "golangci-lint 已安装"
  else
    mkdir -p "$HOME/.local/bin"
    run_install "curl 安装 golangci-lint 到 ~/.local/bin" "golangci-lint 安装完成" \
      bash -c 'curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b "$HOME/.local/bin"'
  fi

  # ruff（pipx 安装）
  if command -v ruff &>/dev/null; then
    skip "ruff 已安装"
  else
    if ! command -v pipx &>/dev/null; then
      warn "pipx 未安装，尝试安装 pipx..."
      "${PKG_CMD[@]}" pipx || true
    fi
    if command -v pipx &>/dev/null; then
      run_install "pipx install ruff" "ruff 安装完成" pipx install ruff
    else
      err "pipx 不可用，跳过 ruff"
    fi
  fi

  local npm_missing=()
  for cmd in "${NPM_LINTERS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      skip "$cmd 已安装"
    else
      npm_missing+=("$cmd")
    fi
  done
  install_npm_global "${npm_missing[@]}"
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
