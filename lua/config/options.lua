local opt = vim.opt

-- 外观设置
opt.termguicolors = true
opt.syntax = "on"
opt.number = true
opt.relativenumber = true   -- 当前行绝对、其余相对（混合行号）
opt.cursorline = true
opt.cursorlineopt = "both"  -- 高亮光标所在整行 + 行号
opt.wrap = true
opt.showcmd = true
opt.wildmenu = true
opt.signcolumn = "yes"     -- 符号栏常驻，避免行号跳动
opt.winborder = "rounded"  -- 浮动窗口默认圆角边框（LSP hover、诊断浮窗等统一）
opt.colorcolumn = "80,100" -- 80/100 列竖线标尺（对应 VSCode editor.rulers）

-- 搜索设置
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- 执行 nohlsearch
vim.cmd("nohlsearch")

-- 兼容性和文件类型设置
opt.compatible = false
vim.cmd("filetype plugin indent on")

-- 编码设置
opt.encoding = "utf-8"

-- 缩进和制表符设置
-- opt.expandtab = true
-- opt.tabstop = 4
-- opt.shiftwidth = 4
-- opt.softtabstop = 4
-- opt.list = true

-- 编辑器行为设置
opt.scrolloff = 5
opt.textwidth = 0
opt.indentexpr = ""
opt.backspace = { "indent", "eol", "start" }

-- 交互响应
opt.updatetime = 250       -- CursorHold 更快触发（LSP hover / gitsigns）
opt.timeoutlen = 300       -- which-key / 按键序列更跟手

-- 分屏方向
opt.splitright = true      -- vsplit 在右侧
opt.splitbelow = true      -- split 在下方

-- 省心
opt.confirm = true         -- :q 有改动时提示保存，而不是报错
opt.swapfile = false
opt.backup = false

-- 持久化 undo（跨会话保留 undo 历史）
-- 目录不存在时 undo 写入会静默失败，启动时显式确保目录存在
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.fn.mkdir(undodir, "p")
opt.undofile = true
opt.undodir = undodir

-- 折叠设置
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
opt.foldlevel = 99

-- 工作目录设置（关闭自动 cd，避免 telescope/nvim-tree 根目录漂移）
opt.autochdir = false

-- 剪贴板设置（使用系统剪贴板 + 寄存器）
opt.clipboard = "unnamedplus"

-- vscode-neovim：用其内置 provider 同步 VS Code 剪贴板，跳过 win32yank
if vim.g.vscode then
  vim.g.clipboard = vim.g.vscode_clipboard
end

-- WSL：用 win32yank.exe 桥接 Windows 剪贴板
-- exe 随本仓库分发（stdpath("config")/win32yank.exe），不依赖 PATH；
-- 命令用列表形式（不过 shell，路径含空格也安全）。
-- 仅在 WSL 且 exe 可执行时启用，避免污染原生 Linux / macOS 的 provider。
if not vim.g.vscode and vim.fn.has("wsl") == 1 then
  local win32yank = vim.fn.stdpath("config") .. "/bin/win32yank.exe"
  if vim.fn.executable(win32yank) == 1 then
    vim.g.clipboard = {
      name = "win32yank-wsl",
      copy = {
        ["+"] = { win32yank, "-i", "--crlf" },
        ["*"] = { win32yank, "-i", "--crlf" },
      },
      paste = {
        ["+"] = { win32yank, "-o", "--lf" },
        ["*"] = { win32yank, "-o", "--lf" },
      },
      cache_enabled = 0,  -- win32yank 无 owner 概念，关缓存（官方推荐）
    }
  end
end

-- 终端配色（Campbell，与 Windows Terminal 一致）
-- 在 colorscheme 加载后覆盖，防止主题插件覆盖
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.g.terminal_color_0  = '#0C0C0C'
    vim.g.terminal_color_1  = '#C50F1F'
    vim.g.terminal_color_2  = '#13A10E'
    vim.g.terminal_color_3  = '#C19C00'
    vim.g.terminal_color_4  = '#0037DA'
    vim.g.terminal_color_5  = '#881798'
    vim.g.terminal_color_6  = '#3A96DD'
    vim.g.terminal_color_7  = '#CCCCCC'
    vim.g.terminal_color_8  = '#767676'
    vim.g.terminal_color_9  = '#E74856'
    vim.g.terminal_color_10 = '#16C60C'
    vim.g.terminal_color_11 = '#F9F1A5'
    vim.g.terminal_color_12 = '#3B78FF'
    vim.g.terminal_color_13 = '#B4009E'
    vim.g.terminal_color_14 = '#61D6D6'
    vim.g.terminal_color_15 = '#F2F2F2'
  end,
})

