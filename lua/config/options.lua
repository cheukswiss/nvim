-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- 外观设置
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
vim.cmd("filetype on")
vim.cmd("filetype indent on")
vim.cmd("filetype plugin on")
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