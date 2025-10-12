-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

-- 增强移动键
map("n", "J", "5j")
map("n", "K", "5k")  
map("n", "H", "5h")
map("n", "L", "5l")

-- 取消搜索高亮
map("n", "<leader><CR>", ":nohlsearch<CR>")

-- 16进制编辑
map("n", "<leader>xd", ":%!xxd<CR>")
map("n", "<leader>nxd", ":%!xxd -r<CR>")

-- 禁用s键，重新映射保存和退出
map("n", "s", "<nop>")
map("n", "S", ":w<CR>")
map("n", "Q", ":q<CR>") 
map("n", "E", ":e!<CR>")

-- =========================
--         窗口操作
-- =========================

-- 窗口布局切换
map("n", "sv", "<C-w>t<C-w>H")
map("n", "sh", "<C-w>t<C-w>K")

-- 窗口分割
map("n", "si", ":set splitright<CR>:vsplit<CR>")
map("n", "sn", ":set nosplitright<CR>:vsplit<CR>")
map("n", "su", ":set nosplitbelow<CR>:split<CR>")
map("n", "se", ":set splitbelow<CR>:split<CR>")

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
map("n", "sma", ":set mouse=a<CR>")
map("n", "smc", ":set mouse=a<CR>")

-- 会话保存和加载
map("n", "sms", ":mksession ./.session.vim<CR>")
map("n", "sls", ":source ./.session.vim<CR>")

-- =========================
--         标签页操作  
-- =========================

-- 新建和关闭标签页
map("n", "tu", ":tabe<CR>")
map("n", "tc", ":tabclose<CR>")

-- 标签页切换
map("n", "<A-[>", ":-tabnext<CR>")
map("n", "<A-]>", ":+tabnext<CR>")
map("n", "<A-=>", ":bn<CR>")
map("n", "<A-->", ":bp<CR>")

-- Alt+数字切换标签页 (需要airline插件支持)
for i = 1, 9 do
    map("n", "<A-" .. i .. ">", "<cmd>lua vim.cmd('AirlineSelectTab" .. i .. "')<CR>")
end

-- =========================
--        插件键位映射
-- =========================

-- NERDTree 文件树操作
map("n", "<leader>n", ":NERDTreeFocus<CR>")
map("n", "tt", ":NERDTreeToggle<CR>")
map("n", "tf", ":NERDTreeFind<CR>")

-- LeaderF 文件搜索
map("n", "<C-p>", ":Leaderf file<CR>")

-- COC 代码导航
map("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
map("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
map("n", "gd", "<Plug>(coc-definition)", { silent = true })
map("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
map("n", "gi", "<Plug>(coc-implementation)", { silent = true })
map("n", "gr", "<Plug>(coc-references)", { silent = true })