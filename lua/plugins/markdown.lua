-- Markdown 预览/渲染用 VS Code 自带功能，vscode-neovim 下禁用
if vim.g.vscode then
  return {}
end

return {
  -- 终端内 Markdown 渲染（标题/表格/代码块/链接等直接在 buffer 中可视化）
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown render" },
    },
    opts = {
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
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
      -- WSL2: 使用 Windows 浏览器打开
      if vim.fn.has("wsl") == 1 then
        vim.g.mkdp_browser = "wslview"
      end
    end,
  },
}
