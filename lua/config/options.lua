local opt = vim.opt

-- 外观设置
opt.termguicolors = true
opt.syntax = "on"
opt.number = true
opt.relativenumber = true   -- 当前行绝对、其余相对（混合行号）
opt.cursorline = true
opt.cursorlineopt = "both"  -- 高亮光标所在整行 + 行号
opt.wrap = false
opt.showcmd = true
opt.wildmenu = true
-- noice 把 : 命令行改成居中浮窗，原生命令行区域常年空着仍占一行，故收为 0；
-- 消息由 noice 路由到右上角 nvim-notify 弹窗，可视模式选中量由 lualine 的
-- selectioncount 组件承接。未点完的按键序列（showcmd）就此没有显示位置：
-- 试过 showcmdloc=statusline + lualine %S 组件，实际用不上，已一并去掉。
opt.cmdheight = 0
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

vim.filetype.add({
  filename = {
    [".config"] = "make",
  },
  pattern = {
    [".*_defconfig"] = "make",
  },
})

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

-- 是否 SSH 远程会话：tmux 里 SSH_TTY/SSH_CONNECTION 不会传播到老 pane 启动的
-- 进程，故进程环境缺失时回退查 tmux session 环境（update-environment 默认含
-- SSH_CONNECTION，attach 时刷新；SSH_TTY 不在该列表，只能靠 SSH_CONNECTION）。
local remote = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
if not remote and vim.env.TMUX then
  local out = vim.fn.system({ "tmux", "show-environment", "SSH_CONNECTION" })
  remote = vim.v.shell_error == 0 and out:match("^SSH_CONNECTION=") ~= nil
end

-- vscode-neovim：用其内置 provider 同步 VS Code 剪贴板，跳过 win32yank
if vim.g.vscode then
  vim.g.clipboard = vim.g.vscode_clipboard

-- SSH 远程：复制走 OSC 52 经终端转义序列透传到本地电脑（依赖 tmux
-- set-clipboard on 中继）；win32yank 在远程访问宿主机剪贴板会被拒。
-- 粘贴不走 OSC 52 读回——多数终端禁止读回，内置 "osc52" 会让每次 p
-- 发查询并卡 1s 弹提示；这里用会话内缓存供 p 取用（nvim 内 yy/p 照常）。
-- 跨机器粘贴本地剪贴板内容请用终端原生粘贴（Ctrl+Shift+V / 右键），
-- 它走 bracketed paste、不经寄存器，不受此影响。
elseif remote then
  local copy_fn = require("vim.ui.clipboard.osc52").copy("+")
  local cache = { { "" }, "v" }  -- { lines, regtype }，记住本会话最近一次系统复制
  local function set(lines, regtype)
    cache = { lines, regtype }
    copy_fn(lines)
  end
  local function get()
    return cache
  end
  vim.g.clipboard = {
    name = "osc52-copy-only",
    copy = { ["+"] = set, ["*"] = set },
    paste = { ["+"] = get, ["*"] = get },
  }

-- WSL：用 win32yank.exe 桥接 Windows 剪贴板
-- exe 随本仓库分发（stdpath("config")/win32yank.exe），不依赖 PATH；
-- 命令用列表形式（不过 shell，路径含空格也安全）。
-- 仅在 WSL 且 exe 可执行时启用，避免污染原生 Linux / macOS 的 provider。
elseif vim.fn.has("wsl") == 1 then
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

-- 浮动窗口边框配色（LSP hover、诊断浮窗等）
-- 主题默认未给 FloatBorder 设置 fg，边框与背景几乎融为一体，这里显式高亮
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#569CD6", bg = "#202020" })
  end,
})
