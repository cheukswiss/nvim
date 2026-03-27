# Neovim Configuration

基于 Lua 的轻量 Neovim 配置，使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件，Neovim 0.11+ 原生 LSP API。

## 目录结构

```
~/.config/nvim/
├── init.lua                  # 入口文件
├── lua/
│   ├── config/
│   │   ├── options.lua       # 基础选项
│   │   ├── keymaps.lua       # 快捷键映射
│   │   └── lazy.lua          # lazy.nvim 插件管理器配置
│   └── plugins/
│       └── example.lua       # 插件定义
└── README.md
```

## 插件列表

| 插件 | 用途 |
|------|------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | 配色方案 (tokyonight-night) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮 |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | 模糊搜索 |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | 文件树 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自动补全括号 |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | 快速注释 |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | 括号/引号包裹操作 |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 状态标记 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server 安装管理 |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 配置 |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 代码补全 |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 代码片段 |

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

### 标签页

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `tu` | Normal | 新建标签页 |
| `tc` | Normal | 关闭标签页 |
| `<A-[>` | Normal | 上一个标签页 |
| `<A-]>` | Normal | 下一个标签页 |
| `<A-=>` | Normal | 下一个 buffer |
| `<A-->` | Normal | 上一个 buffer |
| `<A-1>` ~ `<A-9>` | Normal | 跳转到第 N 个标签页 |

### 会话管理

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `sma` | Normal | 启用鼠标 |
| `smc` | Normal | 启用鼠标 |
| `sms` | Normal | 保存会话 |
| `sls` | Normal | 加载会话 |

### Telescope (模糊搜索)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-p>` | Normal | 搜索文件 |
| `<leader>fg` | Normal | 全局内容搜索 |
| `<leader>fb` | Normal | 切换 buffer |
| `<leader>fh` | Normal | 搜索帮助文档 |

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
| `<Tab>` | Insert | 选择下一个补全项 |
| `<S-Tab>` | Insert | 选择上一个补全项 |
| `<CR>` | Insert | 确认补全 |
| `<C-Space>` | Insert | 手动触发补全 |
| `<C-e>` | Insert | 关闭补全菜单 |
| `<C-b>` | Insert | 向上滚动文档 |
| `<C-f>` | Insert | 向下滚动文档 |

## LSP 语言支持

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
