if vim.g.vscode then
  return {}
end

return {
  -- markview: 终端内 Markdown 渲染
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    keys = {
      { "<leader>mr", "<cmd>Markview toggle<cr>", desc = "Toggle Markdown render" },
    },
    opts = {
      preview = {
        icon_provider = "mini",
      },
    },
  },

  -- 浏览器实时预览（WSL2/本地有效，SSH 远程下不可用）
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown preview" },
    },
    config = function()
      if vim.fn.has("wsl") == 1 then
        vim.g.mkdp_wsl_opener = vim.fn.executable("wslview") == 1 and "wslview"
          or "/mnt/c/Windows/explorer.exe"
        vim.cmd([[
          function! MkdpWslOpen(url) abort
            call jobstart([g:mkdp_wsl_opener, a:url])
          endfunction
        ]])
        vim.g.mkdp_browserfunc = "MkdpWslOpen"
      end
    end,
  },
}
