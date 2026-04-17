# Neovim Configuration

基于 Lua 的轻量 Neovim 配置，使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件，Neovim 0.11+ 原生 LSP API。

本仓库同时管理 tmux、zsh 自定义配置和一键安装脚本。

## 快速安装

```bash
bash ~/.config/nvim/install.sh          # 交互模式（逐项确认）
bash ~/.config/nvim/install.sh --all    # 全部安装
bash ~/.config/nvim/install.sh tmux zsh # 指定模块
```

可选模块：`deps`（系统依赖）、`tmux`、`zsh`、`linters`。

安装脚本会自动完成：
- 检查并安装系统依赖（tmux、xclip/pbcopy、eza、yazi）
- 创建 `~/.tmux.conf` → `tmux.conf` 符号链接
- 在 `~/.zshrc` 末尾追加 `source zsh_custom.zsh`
- 安装 oh-my-zsh 插件（zsh-syntax-highlighting）
- 安装 TPM（tmux 插件管理器）
- 部署自定义 tmux2k 插件（host 状态栏等）
- 安装 linters（shellcheck、cppcheck、ruff、golangci-lint、eslint_d）

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
│       ├── editor.lua        # 编辑器插件 (treesitter/telescope/flash/toggleterm...)
│       ├── lsp.lua           # LSP + linter 插件
│       ├── completion.lua    # 代码补全
│       └── git.lua           # Git 集成
└── README.md
```

## 插件列表

| 插件 | 用途 |
|------|------|
| [vscode.nvim](https://github.com/Mofiqul/vscode.nvim) | 配色方案 (VSCode 风格) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮 / 增量选择 |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | 模糊搜索 |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Telescope fzf 排序器（C 实现，10x 速度提升） |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | 文件树 |
| [flash.nvim](https://github.com/folke/flash.nvim) | 快速跳转 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自动补全括号 |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | 快速注释 |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | 括号/引号包裹操作 |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 状态标记 / hunk 操作 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server 安装管理 |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 配置 |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 代码补全 |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 代码片段 |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer 标签栏 |
| [bufdelete.nvim](https://github.com/famiu/bufdelete.nvim) | 安全关闭 Buffer |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | 快捷键提示 |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | 缩进参考线 |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | 浮动终端 |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | 异步 linter 集成（shellcheck、ruff、eslint_d 等） |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Mason 与 lspconfig 桥接 |

## 快捷键

Leader 键为 `Space`。

### 基础操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `jj` | Insert | 退出插入模式 |
| `S` | Normal | 保存文件 |
| `Q` | Normal | 退出 |
| `E` | Normal | 重新加载文件 |
| `s` | Normal | 禁用（无操作） |
| `<leader>;` | Normal | 进入命令模式（等同于 `:`) |

### 增强移动

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `J` | Normal | 向下移动 5 行 |
| `K` | Normal | 向上移动 5 行 |
| `H` | Normal | 向左移动 5 列 |
| `L` | Normal | 向右移动 5 列 |

### 搜索

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader><CR>` | Normal | 取消搜索高亮 |

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
| `sv` | Normal | 切换为左右布局 |
| `sh` | Normal | 切换为上下布局 |
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

### 终端

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<A-\>` | Normal/Terminal | 唤起/关闭浮动终端 |

### 会话管理

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `sma` | Normal | 启用鼠标 |
| `smc` | Normal | 禁用鼠标（便于终端原生选中复制） |
| `sms` | Normal | 保存会话 |
| `sls` | Normal | 加载会话 |

### Flash (快速跳转)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader><leader>` | Normal/Visual/Operator | 输入字符后快速跳转到目标 |
| `<leader>.` | Normal/Visual/Operator | Treesitter 节点选择 |
| `r` | Operator | 远程 Flash 跳转 |

### Telescope (模糊搜索)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-p>` | Normal | 搜索文件 |
| `<leader>ff` | Normal | 搜索文件 |
| `<leader>fr` | Normal | 最近打开的文件 |
| `<leader>fg` | Normal | 全局内容搜索 |
| `<leader>fb` | Normal | 切换 Buffer |
| `<leader>fh` | Normal | 搜索帮助文档 |
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

### Treesitter 增量选择

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-Space>` | Normal | 开始/扩展选择（按语法节点） |
| `<BS>` | Visual | 缩小选择 |

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

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `gd` | Normal | 跳转定义 |
| `gr` | Normal | 查看引用 |
| `gi` | Normal | 跳转实现 |
| `gy` | Normal | 跳转类型定义 |
| `gk` | Normal | 悬浮文档 |
| `<leader>rn` | Normal | 重命名 |
| `<leader>ca` | Normal | 代码操作 |
| `[d` | Normal | 上一个诊断 |
| `]d` | Normal | 下一个诊断 |

### 代码补全 (nvim-cmp)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<Tab>` | Insert | 选择下一个补全项 / 跳转 snippet |
| `<S-Tab>` | Insert | 选择上一个补全项 / 反跳 snippet |
| `<CR>` | Insert | 确认补全 |
| `<C-Space>` | Insert | 手动触发补全 |
| `<C-e>` | Insert | 关闭补全菜单 |
| `<C-b>` | Insert | 向上滚动文档 |
| `<C-f>` | Insert | 向下滚动文档 |

## LSP 语言支持

使用 Neovim 0.11+ 原生 API（`vim.lsp.config` / `vim.lsp.enable`）配置。

已启用的 LSP server：

| Server | 语言 | 系统依赖 |
|--------|------|---------|
| `lua_ls` | Lua | 无 (Mason 自动安装) |
| `pyright` | Python | npm |
| `gopls` | Go | go |
| `ts_ls` | TypeScript / JavaScript | npm |
| `clangd` | C / C++ | clangd (`apt install clangd`) |
| `rust_analyzer` | Rust | rustup |
| `bashls` | Bash / Shell | npm |

通过 `:Mason` 命令打开安装界面，按 `i` 安装对应 server。

## Tmux 配置

前缀键改为 `Alt-b`（替代默认的 `Ctrl-b`）。macOS iTerm2 需在 Profiles → Keys → Left Option key 设置为 `Esc+`。

### Tmux 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Alt-h/j/k/l` | 面板导航（无需前缀） |
| `Alt-Shift-H/J/K/L` | 调整面板大小（无需前缀） |
| `Alt-I` | 垂直分屏 |
| `Alt-V` | 水平分屏 |
| `Alt-n` | 上一个窗口 |
| `Alt-m` | 下一个窗口 |
| `Alt-T` | 新建窗口 |
| `Alt-W` | 关闭面板（最后一个面板时确认退出） |
| `Alt-Q` | 确认退出 tmux |
| `Alt-B` | 分离 tmux |
| `Alt-\` | 浮动终端（nvim 内透传给 nvim，再按关闭，scratch 会话持久化） |
| `Alt-g` | lazygit 浮动窗口 |
| `Alt-f` | tmux-thumbs 快速复制（标签标记屏幕文本） |
| `前缀 + r` | 重载配置 |
| `前缀 + Esc` | 进入复制模式 |
| `前缀 + P` | 粘贴 |

复制模式使用 Vi 键位：`v` 选择，`y` / `Enter` / 鼠标释放即复制并退出（自动写入系统剪贴板），滚轮每次 1 行。

### Tmux 插件

| 插件 | 用途 |
|------|------|
| tmux-sensible | 合理默认值 |
| tmux-resurrect | 会话保存/恢复 |
| tmux-continuum | 自动保存（15 分钟间隔） |
| tmux2k | 状态栏主题（置顶，显示 session/git/cwd/host/cpu/ram/network/time） |
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
