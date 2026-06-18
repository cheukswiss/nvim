# Neovim Configuration

基于 Lua 的轻量 Neovim 配置，使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件，Neovim 0.12+ 原生 LSP API。

本仓库同时管理 tmux、zsh 自定义配置和一键安装脚本。

## 快速安装

```bash
bash ~/.config/nvim/install.sh          # 交互模式（逐项确认）
bash ~/.config/nvim/install.sh --all    # 全部安装
bash ~/.config/nvim/install.sh tmux zsh # 指定模块
```

可选模块：`deps`（系统依赖）、`tmux`、`zsh`、`linters`。

安装脚本会自动完成：
- 检查并安装系统依赖（tmux、xclip/pbcopy、ripgrep、fd、eza、yazi、glow、tree-sitter-cli）
- 创建 `~/.tmux.conf` → `tmux.conf` 符号链接
- 在 `~/.zshrc` 末尾追加 `source zsh_custom.zsh`
- 安装 oh-my-zsh 插件（zsh-syntax-highlighting）
- 安装 TPM（tmux 插件管理器）
- 部署自定义 tmux2k 插件（host 状态栏等）
- 安装 linters（shellcheck、cppcheck、ruff、golangci-lint、eslint_d）

> **注意**：`nvim-treesitter` 已切到 main 分支（Neovim 0.12+ 原生栈），依赖系统级 `tree-sitter` CLI 编译 parser。`install.sh deps` 会通过 `npm -g tree-sitter-cli` 自动装好；未安装时打开任何源码文件都会报 `Error during "tree-sitter build"`。

## 目录结构

```
~/.config/nvim/
├── init.lua                  # 入口文件
├── install.sh                # dotfiles 交互式安装脚本
├── tmux.conf                 # tmux 配置
├── zsh_custom.zsh            # zsh 自定义配置
├── tmux2k-custom/            # 自定义 tmux2k 插件（官方未提供）
│   └── host.sh               # 状态栏 host 显示
├── lua/
│   ├── config/
│   │   ├── options.lua       # 基础选项
│   │   ├── keymaps.lua       # 快捷键映射
│   │   ├── autocmds.lua      # 自动命令
│   │   └── lazy.lua          # lazy.nvim 插件管理器配置
│   └── plugins/
│       ├── ui.lua            # 界面插件 (主题/状态栏/bufferline)
│       ├── editor.lua        # 编辑器插件 (treesitter/telescope/flash...)
│       ├── lsp.lua           # LSP + linter 插件
│       ├── completion.lua    # 代码补全
│       ├── markdown.lua      # Markdown 渲染 / 预览
│       └── git.lua           # Git 集成
└── README.md
```

## 插件列表

| 插件 | 用途 |
|------|------|
| [vscode.nvim](https://github.com/Mofiqul/vscode.nvim) | 配色方案 (VSCode 风格) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法 parser 管理（main 分支，0.12+） |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | 模糊搜索 |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Telescope fzf 排序器（C 实现，10x 速度提升） |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | 文件树 |
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | 代码大纲侧栏（LSP/treesitter 符号） |
| [flash.nvim](https://github.com/folke/flash.nvim) | 快速跳转 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自动补全括号 |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | 快速注释 |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | TODO/FIXME/HACK 高亮与检索 |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | 括号/引号包裹操作 |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 状态标记 / hunk 操作 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server / 工具二进制安装 |
| [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | 启动时自动确保所需工具已安装 |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server 默认配置（0.11+ lsp/*.lua 格式） |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | lua_ls 识别 Neovim / 插件 Lua API 类型 |
| [blink.cmp](https://github.com/saghen/blink.cmp) | 代码补全（Rust 实现，替代 nvim-cmp） |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 代码片段引擎 |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 通用 snippet 集 |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer 标签栏 |
| [bufdelete.nvim](https://github.com/famiu/bufdelete.nvim) | 安全关闭 Buffer |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | 快捷键提示 |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | 缩进参考线 |
| [noice.nvim](https://github.com/folke/noice.nvim) | 命令行浮窗（仅接管 cmdline，command_palette 布局） |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | 异步 linter 集成（shellcheck、ruff、eslint_d、cppcheck 等） |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | 格式化集成（clang-format，`<leader>cf` 手动） |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | 终端内 Markdown 渲染 |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | 浏览器 Markdown 预览 |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | AI 助手：对话 / 行内重构 / agent（接 DeepSeek） |

AI 补全通过 [minuet-ai.nvim](https://github.com/milanglacier/minuet-ai.nvim) 接入 DeepSeek，以 ghost text（行内灰字）展示。API key 从配置目录下的 `.env`（`DEEPSEEK_API_KEY=...`，已被 `.gitignore` 忽略）读取，由 `lua/config/env.lua` 在启动时注入环境变量。后端、模型、键位见 `lua/plugins/completion.lua`。

AI 助手（对话 / 按指令改代码 / agent）通过 [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) 接入 DeepSeek（模型 `deepseek-v4-pro`），与 minuet 的行内补全互补。复用同一把 `DEEPSEEK_API_KEY`（内置 deepseek adapter 默认读该环境变量）。配置见 `lua/plugins/ai.lua`；聊天面板内可用 `ga` 临时切换模型。

## 快捷键

Leader 键为 `Space`。

### 基础操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `jj` | Insert | 退出插入模式 |
| `S` | Normal | 保存文件 |
| `Q` | Normal | 退出 |
| `E` | Normal | 放弃修改并重载文件 |
| `s` | Normal/Visual/Operator | 快速跳转（Flash，详见下方表格） |
| `<leader>;` | Normal | 进入命令模式（等同于 `:`) |

### 增强移动

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `J` | Normal/Visual | 向下移动 5 行 |
| `K` | Normal/Visual | 向上移动 5 行 |
| `H` | Normal/Visual | 跳到行首第一个非空白字符 |
| `L` | Normal/Visual | 跳到行尾 |

### 搜索

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `*` | Normal | 原地高亮光标下的词（光标不动，之后用 `n`/`N` 跳转） |
| `*` | Visual | 搜索选中的文本（设高亮，之后用 `n`/`N` 跳转） |
| `<leader><CR>` | Normal | 取消搜索高亮 |

### 文件路径 / 打开

复制类键位写入系统剪贴板（`+` 寄存器），并弹通知显示复制内容。

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>yp` | Normal | 复制相对路径（相对 cwd） |
| `<leader>yP` | Normal | 复制绝对路径 |
| `<leader>yn` | Normal | 复制文件名 |
| `<leader>yd` | Normal | 复制所在目录（绝对） |
| `<leader>yw` | Normal | 复制工作目录 / 工程根（`getcwd`） |
| `<leader>fe` | Normal | 在「当前文件所在目录」下开新文件（命令行预填目录，`Tab` 补全） |
| `gf` | Normal | 打开光标下的路径（内置） |
| `<C-w>f` | Normal | 光标下路径在分屏中打开（内置） |

### 16 进制编辑

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>xd` | Normal | 转为 16 进制显示 |
| `<leader>nxd` | Normal | 从 16 进制还原 |

### 窗口操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>si` | Normal | 垂直分割窗口 |
| `<leader>sv` | Normal | 水平分割窗口 |
| `<leader>wv` | Normal | 切换为左右布局 |
| `<leader>wh` | Normal | 切换为上下布局 |
| `<leader>h/j/k/l` | Normal | 窗口间移动 |
| `<up>/<down>` | Normal | 调整窗口高度 |
| `<left>/<right>` | Normal | 调整窗口宽度 |

### Buffer 操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<A-[>` | Normal | 上一个 Buffer |
| `<A-]>` | Normal | 下一个 Buffer |
| `<A-1>` ~ `<A-9>` | Normal | 跳转到第 N 个 Buffer |
| `<leader>bc` | Normal | 关闭当前 Buffer |
| `<leader>bo` | Normal | 关闭其他 Buffer |

### 会话管理

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>ma` | Normal | 启用鼠标 |
| `<leader>mc` | Normal | 禁用鼠标（便于终端原生选中复制） |
| `<leader>ss` | Normal | 保存会话 |
| `<leader>sl` | Normal | 加载会话 |

### Flash (快速跳转)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `s` | Normal/Visual/Operator | 输入字符后快速跳转到目标 |
| `<leader>.` | Normal/Visual/Operator | Treesitter 节点选择 |
| `r` | Operator | 远程 Flash 跳转 |

### Telescope (模糊搜索)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-p>` | Normal | 搜索文件 |
| `<leader>ff` | Normal | 搜索文件 |
| `<leader>fF` | Normal | 搜索文件（范围限定当前文件目录） |
| `<leader>fa` | Normal | 搜索全部文件（含 .gitignore 忽略与隐藏文件） |
| `<leader>fr` | Normal | 最近打开的文件 |
| `<leader>fg` | Normal | 全局内容搜索 |
| `<leader>fg` | Visual | 用选中文本做全局内容搜索（grep_string） |
| `<leader>fb` | Normal | 切换 Buffer |
| `<leader>fh` | Normal | 搜索帮助文档 |
| `<leader>ft` | Normal | 搜索 TODO/FIXME 等标记（TodoTelescope） |
| `]t` / `[t` | Normal | 跳到下/上一个 TODO 注释 |
| `<leader>/` | Normal | 当前 Buffer 内搜索 |
| `<leader>fs` | Normal | 文档符号 |
| `<leader>fS` | Normal | 工作区符号 |
| `<leader>fd` | Normal | 诊断列表 |
| `<leader>gc` | Normal | Git 提交历史 |
| `<leader>gs` | Normal | Git 状态 |
| `<leader>gb` | Normal | Git 分支 |

Telescope 内部快捷键：`<C-j>`/`<C-k>` 上下移动，`<Esc>` 关闭。

### 文件树 (nvim-tree)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `tt` | Normal | 开关文件树 |
| `tf` | Normal | 在文件树中定位当前文件 |
| `<leader>o` | Normal | 开关代码大纲侧栏（aerial） |

文件树不自动定位当前文件（`update_focused_file` 关闭）；需要时用 `tf` 手动定位。

### 注释 (Comment.nvim)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-/>` | Normal | 注释/取消注释当前行 |
| `<C-/>` | Visual | 注释/取消注释选中内容 |
| `gcc` | Normal | 注释/取消注释当前行 |
| `gc` | Visual | 注释/取消注释选中内容 |

### 包裹操作 (nvim-surround)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `ysaw)` | Normal | 给单词加括号 |
| `ds"` | Normal | 删除引号包裹 |
| `cs"'` | Normal | 双引号换单引号 |

### Git (gitsigns)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `]c` | Normal | 下一个 hunk |
| `[c` | Normal | 上一个 hunk |
| `<leader>ip` | Normal | 预览 hunk |
| `<leader>is` | Normal/Visual | Stage hunk |
| `<leader>ir` | Normal/Visual | Reset hunk |
| `<leader>iS` | Normal | Stage 整个文件 |
| `<leader>iR` | Normal | Reset 整个文件 |
| `<leader>iu` | Normal | 撤销 Stage hunk |
| `<leader>ib` | Normal | 当前行 Blame |
| `<leader>iB` | Normal | 切换行内 Blame 显示 |
| `<leader>id` | Normal | Diff 当前文件 |
| `<leader>iD` | Normal | Diff 当前文件 vs HEAD~ |
| `<leader>itd` | Normal | 切换显示已删除行 |
| `ih` | Visual/Operator | 选中当前 hunk（text object） |

### LSP (语言服务)

本配置的自定义映射：

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `gd` | Normal | 跳转定义 |
| `gh` | Normal | 悬浮文档 |
| `<leader>rn` | Normal | 重命名 |
| `<leader>ca` | Normal | 代码操作 |
| `<leader>cf` | Normal | 格式化当前缓冲区（conform，LSP 兜底） |
| `[d` | Normal | 上一个诊断 |
| `]d` | Normal | 下一个诊断 |
| `<leader>th` | Normal | 切换 inlay hints（参数名/类型，服务端支持时默认开启） |

> **格式化**：保存时不自动格式化；用 `<leader>cf` 手动经 [conform.nvim](https://github.com/stevearc/conform.nvim) 格式化当前缓冲区（c/cpp 走 clang-format，其余回退 LSP）。

Neovim 0.11+ 内置 LSP 默认映射（无需配置即可使用）：

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `grn` | Normal | 重命名 |
| `gra` | Normal / Visual | 代码操作 |
| `grr` | Normal | 查看引用 |
| `gri` | Normal | 跳转实现 |
| `grt` | Normal | 跳转类型定义 |
| `gO` | Normal | 文档符号列表 |
| `<C-S>` | Insert | 签名帮助 |

> 注：Neovim 默认的 `K` 悬浮已被本配置（`keymaps.lua`）覆盖为"上移 5 行"，请使用 `gh` 触发 hover。

### AI 补全 (minuet-ai + DeepSeek)

minuet-ai 接 DeepSeek，以 ghost text（行内灰字）展示，所有文件类型自动触发。

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-l>` | Insert | 接受整段建议 |
| `<C-j>` | Insert | 仅接受一行 |
| `<M-]>` | Insert | 下一个建议 |
| `<M-[>` | Insert | 上一个建议 |
| `<M-e>` | Insert | 取消当前建议 |

### AI 助手 (codecompanion + DeepSeek)

对话 / 按指令改代码 / agent，主动触发（前缀 `<leader>a` = AI）。

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>aa` | Normal/Visual | 动作面板（所有功能入口） |
| `<leader>ac` | Normal/Visual | 开关聊天窗口 |
| `<leader>ai` | Normal/Visual | 行内指令（Visual 时作用于选区） |
| `<leader>ad` | Visual | 把选区加入聊天作上下文 |

### 代码补全 (blink.cmp)

使用 blink.cmp 的 `default` 预设键位：

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-Space>` | Insert | 手动触发 / 显示文档 |
| `<C-n>` | Insert | 下一项 |
| `<C-p>` | Insert | 上一项 |
| `<C-y>` | Insert | 确认补全 |
| `<C-e>` | Insert | 关闭补全菜单 |
| `<Tab>` / `<S-Tab>` | Insert | snippet 占位符前进 / 回退 |

## LSP 语言支持

使用 Neovim 0.11+ 原生 API（`vim.lsp.config` / `vim.lsp.enable`）配置，server 安装由 `mason-tool-installer` 启动时自动确保。

已启用的 LSP server：

| Server | 语言 / 功能 | Mason 包名 |
|--------|------|---------|
| `lua_ls` | Lua | `lua-language-server` |
| `pyright` | Python | `pyright` |
| `gopls` | Go | `gopls` |
| `ts_ls` | TypeScript / JavaScript | `typescript-language-server` |
| `clangd` | C / C++ | `clangd` |
| `rust_analyzer` | Rust | `rust-analyzer` |
| `bashls` | Bash / Shell | `bash-language-server` |

列表由 `lua/plugins/lsp.lua` 顶部的 `servers` table 单一驱动。手动管理可用 `:Mason` 界面按 `i` 安装。

### 格式化与诊断

LSP server 之外的工具（formatter / linter）经 `mason-tool-installer` 一并自动安装：

| 工具 | 类型 | 适用语言 | Mason 包名 |
|------|------|---------|-----------|
| `clang-format` | formatter（conform） | C / C++ | `clang-format` |

C / C++ 当前能力：clangd 跳转·补全·hover·重命名·代码操作·诊断·inlay hints + clang-format 手动格式化（`<leader>cf`）+ `cpp` treesitter parser + Doxygen 注释高亮（`@brief`/`@param` 等，经注入的 `doxygen` parser）。

## VS Code（vscode-neovim）兼容

本配置可直接被 [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) 加载（`vim.g.vscode` 分支）：

- **禁用**：UI（lualine/bufferline/nvim-tree/telescope 等）、LSP/Mason、补全、gitsigns、markdown、autopairs——均由 VS Code 接管
- **保留**：treesitter（供 flash 选区）、Comment、surround、flash、路径复制（`<leader>y*`）及所有 normal/visual 键位
- **桥接键位**：`Q` 关闭标签页、`E` 放弃修改重载、`<leader>h/j/k/l` 跳分屏、`<leader>si/sv` 分屏、`tt` 资源管理器、`<leader>ff/fg` 快速打开/全局搜索、`<C-/>` 注释

VS Code 侧需在 settings.json 配置（无法随本仓库分发）：

```jsonc
{
  // WSL 下必须启用，nvim 跑在 WSL 内
  "vscode-neovim.useWSL": true,
  // 插入模式按键不经过 nvim，jj 退出需用 composite keys（插件 ≥ v1.5）
  "vscode-neovim.compositeKeys": {
    "jj": { "command": "vscode-neovim.escape" }
  }
}
```

> 注意：旧方案的 `compositeEscape1/2` keybindings 已废弃，若 keybindings.json 中有残留需删除，否则按 `j` 会报错。

## Tmux 配置

前缀键改为 `Alt-b`（替代默认的 `Ctrl-b`）。macOS iTerm2 需在 Profiles → Keys → Left Option key 设置为 `Esc+`。

### Tmux 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Alt-h/j/k/l` | 面板导航（无需前缀） |
| `Alt-z` | 缩放当前面板（无需前缀） |
| `Alt-s` | 会话树切换（无需前缀） |
| `Alt-Shift-H/J/K/L` | 调整面板大小（无需前缀） |
| `Alt-I` | 垂直分屏 |
| `Alt-V` | 水平分屏 |
| `Alt-n` | 上一个窗口 |
| `Alt-m` | 下一个窗口 |
| `Alt-Shift-N` | 当前窗口左移一位 |
| `Alt-Shift-M` | 当前窗口右移一位 |
| `Alt-T` | 新建窗口 |
| `Alt-W` | 关闭面板（最后一个面板时确认退出） |
| `Alt-Q` | 确认退出 tmux |
| `Alt-B` | 分离 tmux |
| `Alt-\` | 浮动终端（再按关闭，scratch 会话持久化） |
| `Alt-g` | lazygit 浮动窗口 |
| `Alt-f` | tmux-thumbs 快速复制（标签标记屏幕文本） |
| `前缀 + r` | 重载配置 |
| `前缀 + Esc` | 进入复制模式 |
| `前缀 + P` | 粘贴 |

复制模式使用 Vi 键位：`v` 选择，`y` / `Enter` / 鼠标释放即复制并退出（自动写入系统剪贴板），滚轮每次 3 行。

### Tmux 插件

| 插件 | 用途 |
|------|------|
| tmux-sensible | 合理默认值 |
| tmux-resurrect | 会话保存/恢复 |
| tmux-continuum | 自动保存（15 分钟间隔） |
| tmux2k | 状态栏主题（置顶，显示 session/cwd + host/cpu/ram 等，按平台略有差异） |
| tmux-thumbs | 快速复制屏幕文本（URL/路径/git hash/IP 地址） |

## ZSH 自定义配置

`zsh_custom.zsh` 由本仓库管理，在 `~/.zshrc` 中 source：

- `vi`/`vim` 自动指向 `nvim`
- 禁用 `share_history`（各终端独立历史）
- 自动进入 tmux（本地环境自动 attach/new `main` 会话，SSH 跳过）
- `t [name]` 函数：快速创建/连接 tmux 会话（默认 `main`）
- `eza`/`exa` 别名：`ll`（详细列表）、`la`（显示隐藏）、`l`（简洁）
- `y` 函数：启动 yazi 文件管理器并跟随目录切换
- `lg` 函数：启动 lazygit 并跟随目录切换
