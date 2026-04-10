return {
  -- treesitter 语法高亮
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash",
          "c",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "regex",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
      })
    end,
  },

  -- telescope 模糊搜索
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
  },

  -- nvim-tree 文件树
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "tt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "tf", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
    },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- 快捷键提示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- 安全关闭 buffer
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
  },

  -- 自动补全括号
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- gcc 快速注释
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },

  -- 括号/引号包裹操作
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- 浮动终端
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<A-\\>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle float terminal" },
      { "<A-\\>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle float terminal", mode = "t" },
    },
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = {
          border = "curved",
        },
        highlights = {
          Normal = { guibg = '#0C0C0C', guifg = '#CCCCCC' },
          NormalFloat = { guibg = '#0C0C0C', guifg = '#CCCCCC' },
        },
      })
    end,
  },
}
