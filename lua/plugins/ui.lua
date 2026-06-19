-- UI 由 VS Code 渲染，vscode-neovim 下全部禁用
if vim.g.vscode then
  return {}
end

return {
  -- colorscheme
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        color_overrides = { vscBack = "#141414" },
      })
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    config = function()
      require("lualine").setup({
        options = { theme = "vscode" },
      })
    end,
  },

  -- Buffer 标签栏
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-mini/mini.icons" },
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          close_command = "Bdelete! %d",
          right_mouse_command = "Bdelete! %d",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
        },
      })
    end,
  },

  -- 缩进参考线
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup()
    end,
  },

  -- 命令行浮窗（noice，仅接管 cmdline；消息/通知保持原生）
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = { enabled = true, view = "cmdline_popup" },
      messages = { enabled = false },   -- 消息区
      notify = { enabled = false },     -- 通知
      popupmenu = { enabled = true },   -- 命令行候选用 noice 浮窗（配合 command_palette 居中）；插入态补全仍由 blink 独立处理
      lsp = { progress = { enabled = false } },
      presets = { command_palette = true }, -- 命令行 + 候选靠上居中排布
    },
  },
}
