return {
  -- treesitter 语法高亮
  {
    "nvim-treesitter/nvim-treesitter",
    -- 锁定 master 分支（main 分支是新重写版，API 不同且尚在开发中）
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        -- treesitter indent 仍是 experimental，改用 Neovim 内置 ftplugin 的 indent
        indent = { enable = false },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- telescope 模糊搜索
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- C 实现的 fzf 排序器，模糊匹配速度提升 10 倍+
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      -- 文件 / 搜索
      { "<C-p>",      "<cmd>Telescope find_files<cr>",              desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",              desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                desc = "Recent files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",               desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                 desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",               desc = "Help tags" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
      -- LSP / 诊断
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",    desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>",   desc = "Workspace symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>",             desc = "Diagnostics" },
      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<cr>",             desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",              desc = "Git status" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>",            desc = "Git branches" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<Esc>"] = "close",
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
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

  -- 快速跳转（按 <leader><leader> 输入 2 字符，屏幕上出现字母标签直达）
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = { enabled = false }, -- 不劫持 / ? 的行为
        char = { enabled = false },   -- 不劫持 f/F/t/T
      },
    },
    keys = {
      {
        "<leader><leader>",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash jump",
      },
      {
        "<leader>.",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter select",
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote flash",
      },
    },
  },

  -- 浮动终端
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<A-\\>",
        function() vim.cmd(vim.v.count1 .. "ToggleTerm direction=float") end,
        desc = "Toggle float terminal (count = id)",
      },
      {
        "<A-\\>",
        [[<C-\><C-n><cmd>ToggleTerm<cr>]],
        mode = "t",
        desc = "Hide float terminal",
      },
      { "<leader>tl", "<cmd>TermSelect<cr>", desc = "Select terminal" },
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
