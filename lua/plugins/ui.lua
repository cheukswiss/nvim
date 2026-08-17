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

  -- 右上角通知弹窗：渲染样式与动画（noice 会把通知路由到这里）
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "fade_in_slide_out",
      render = "default",
      timeout = 3000,
      top_down = true,
      max_width = 60,
      background_colour = "#141414",
    },
  },

  -- 命令行浮窗 + 通知接管（noice：cmdline 居中浮窗；通知转交 nvim-notify）
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      cmdline = { enabled = true, view = "cmdline_popup" },
      messages = { enabled = false },
      notify = { enabled = true },
      popupmenu = { enabled = true },
      lsp = { progress = { enabled = false } },
      presets = { command_palette = true },
    },
  },
}
