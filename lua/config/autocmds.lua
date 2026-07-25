-- 复制（yank）后闪烁高亮选区，肉眼确认复制范围
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- 退出 Neovim 时自动保存会话到工程根的 Session.vim
local editor_filetypes = {
  gitcommit = true,
  gitrebase = true,
  hgcommit = true,
  mail = true,
  crontab = true,
}

-- nvim 内置 filetype 覆盖不到的临时文件名
local editor_basenames = {
  ["SQUASH_MSG"] = true,
  ["PULLREQ_EDITMSG"] = true,
  ["addp-hunk-edit.diff"] = true,
}

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("auto_save_session", { clear = true }),
  callback = function()
    if vim.g.vscode then
      return
    end

    -- 有真实文件则保存，实例仅剩 git 临时 buffer（一次性 $EDITOR）时跳过
    local has_file = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].buflisted
        and vim.bo[buf].buftype == "" then
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= ""
          and not (editor_filetypes[vim.bo[buf].filetype]
            or editor_basenames[vim.fn.fnamemodify(name, ":t")]) then
          has_file = true
          break
        end
      end
    end

    if not has_file then
      return
    end

    local session = vim.fn.getcwd() .. "/Session.vim"
    if vim.fn.filereadable(session) == 0 then
      return
    end

    pcall(vim.cmd, "NvimTreeClose")

    vim.cmd("mksession! " .. vim.fn.fnameescape(session))
  end,
})
