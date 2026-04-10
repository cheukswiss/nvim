local opt = vim.opt

-- 外观设置
opt.termguicolors = true
opt.syntax = "on"
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.wrap = true
opt.showcmd = true
opt.wildmenu = true

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

-- 折叠设置
opt.foldmethod = "indent"
opt.foldlevel = 99

-- 工作目录设置
opt.autochdir = true

-- 剪贴板设置
opt.clipboard:append("unnamed")

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

