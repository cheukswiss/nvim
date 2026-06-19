-- Markdown 预览/渲染用 VS Code 自带功能，vscode-neovim 下禁用
if vim.g.vscode then
  return {}
end

return {
  -- render-markdown: 终端内 Markdown 渲染
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false, -- Disabled
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
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

  -- markview: 终端内 Markdown 渲染
  {
    "OXY2DEV/markview.nvim",
    -- 作者建议 lazy=false：插件自带懒加载，外部再 ft 懒加载会拖慢首个 .md 的渲染
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
      -- WSL2: 使用 Windows 浏览器打开
      if vim.fn.has("wsl") == 1 then
        vim.g.mkdp_browser = "wslview"
      end
    end,
  },
}
