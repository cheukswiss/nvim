-- 复制（yank）后闪烁高亮选区，肉眼确认复制范围
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- 退出 Neovim 时自动保存会话到工程根的 Session.vim
-- 沿用 <leader>ss 的约定，tmux-resurrect 用 -S 恢复
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("auto_save_session", { clear = true }),
  callback = function()
    if vim.g.vscode then
      return
    end

    local has_file = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].buflisted
        and vim.bo[buf].buftype == ""
        and vim.api.nvim_buf_get_name(buf) ~= "" then
        has_file = true
        break
      end
    end

    if not has_file then
      return
    end

    pcall(vim.cmd, "NvimTreeClose")

    local session = vim.fn.getcwd() .. "/Session.vim"
    vim.cmd("mksession! " .. vim.fn.fnameescape(session))
  end,
})
