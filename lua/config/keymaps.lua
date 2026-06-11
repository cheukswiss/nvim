-- 设置leader键
vim.g.mapleader = " "

-- 快捷键映射函数
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- =========================
--         基础键位映射
-- =========================

-- 插入模式下jj退出到normal模式
map("i", "jj", "<ESC>")

-- 增强移动键（normal + visual；x 模式不影响 operator-pending，如 dH 仍可用）
map({ "n", "x" }, "J", "5j")
map({ "n", "x" }, "K", "5k")
map({ "n", "x" }, "H", "0")
map({ "n", "x" }, "L", "$")

-- leader+; 进入命令模式
map("n", "<leader>;", ":")

-- 取消搜索高亮
map("n", "<leader><CR>", ":nohlsearch<CR>")

-- * 原地高亮光标下的词：只设搜索高亮、光标不动（之后用 n/N 跳转）
map("n", "*", function()
    local cword = vim.fn.expand("<cword>")
    if cword == "" then
        return
    end
    vim.fn.setreg("/", "\\<" .. vim.fn.escape(cword, "\\/") .. "\\>")
    vim.opt.hlsearch = true
    vim.fn.histadd("/", vim.fn.getreg("/"))
end, { desc = "Highlight word under cursor" })

-- 16进制编辑
map("n", "<leader>xd", ":%!xxd<CR>")
map("n", "<leader>nxd", ":%!xxd -r<CR>")

-- 禁用s键，重新映射保存和退出
map("n", "s", "<nop>")
map("n", "S", ":w<CR>")
map("n", "Q", ":q<CR>")
map("n", "E", ":e!<CR>")

-- =========================
--   VS Code（vscode-neovim）
-- =========================
-- 插入模式、UI、LSP 均由 VS Code 接管；这里只桥接需要的操作到
-- VS Code action，然后提前返回，跳过下方纯 nvim 的窗口/Buffer/插件键位。
if vim.g.vscode then
    local vscode = require("vscode")
    local function action(name)
        return function() vscode.action(name) end
    end

    -- 覆盖上方共享键位：关闭/重载走 VS Code action，
    -- :q/:e! 操作的是 nvim 隐藏 buffer，会与 VS Code 文档状态错位
    map("n", "Q", action("workbench.action.closeActiveEditor"))
    map("n", "E", action("workbench.action.files.revert"))

    -- 窗口分割 / 跳转（<C-w> 系列 vscode-neovim 已桥接，这里补 leader 习惯键位）
    map("n", "<leader>si", action("workbench.action.splitEditorRight"))
    map("n", "<leader>sv", action("workbench.action.splitEditorDown"))
    map("n", "<leader>h", action("workbench.action.navigateLeft"))
    map("n", "<leader>j", action("workbench.action.navigateDown"))
    map("n", "<leader>k", action("workbench.action.navigateUp"))
    map("n", "<leader>l", action("workbench.action.navigateRight"))

    -- 文件树 / 搜索，对应 nvim 下的 nvim-tree / telescope
    map("n", "tt", action("workbench.view.explorer"))
    map("n", "<leader>ff", action("workbench.action.quickOpen"))
    map("n", "<leader>fg", action("workbench.action.findInFiles"))

    -- 注释（对应 nvim 下的 Comment.nvim）
    map({ "n", "x" }, "<C-/>", action("editor.action.commentLine"))

    return
end

-- =========================
--         窗口操作
-- =========================

-- 窗口布局切换
map("n", "sv", "<C-w>t<C-w>H")
map("n", "sh", "<C-w>t<C-w>K")

-- 窗口分割
map("n", "<leader>si", ":vsplit<CR>")
map("n", "<leader>sv", ":split<CR>")

-- 窗口间移动
map("n", "<leader>l", "<C-w>l")
map("n", "<leader>k", "<C-w>k")
map("n", "<leader>h", "<C-w>h")
map("n", "<leader>j", "<C-w>j")

-- 窗口大小调整
map("n", "<up>", ":res -5<CR>")
map("n", "<down>", ":res +5<CR>")
map("n", "<left>", ":vertical resize-5<CR>")
map("n", "<right>", ":vertical resize+5<CR>")

-- =========================
--         会话管理
-- =========================

-- 鼠标设置
map("n", "sma", ":set mouse=a<CR>")   -- 启用鼠标
map("n", "smc", ":set mouse=<CR>")    -- 禁用鼠标（便于终端原生选中复制）

-- 会话保存和加载
map("n", "sms", ":mksession ./.session.vim<CR>")
map("n", "sls", ":source ./.session.vim<CR>")

-- =========================
--         Buffer 操作
-- =========================

-- Buffer 切换
map("n", "<A-]>", ":BufferLineCycleNext<CR>")
map("n", "<A-[>", ":BufferLineCyclePrev<CR>")

-- Buffer 关闭
map("n", "<leader>bc", ":Bdelete<CR>")
map("n", "<leader>bo", ":BufferLineCloseOthers<CR>")

-- Alt+数字切换 Buffer
for i = 1, 9 do
    map("n", "<A-" .. i .. ">", function()
        require("bufferline").go_to(i, true)
    end)
end

--=========================
--        插件键位映射
-- =========================

-- Ctrl+/ 注释/取消注释
map("n", "<C-/>", "gcc", { remap = true })
map("v", "<C-/>", "gc", { remap = true })
