return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local parsers = {
        "bash", "c", "cpp", "css", "doxygen", "go", "html", "javascript", "json",
        "json5", "lua", "markdown", "markdown_inline", "python", "regex", "scss",
        "tsx", "typescript", "vim", "vimdoc", "yaml",
      }
      local installed = ts.get_installed()
      local missing = vim.tbl_filter(function(p)
        return not vim.list_contains(installed, p)
      end, parsers)
      if #missing > 0 then
        ts.install(missing)
      end

      -- VS Code 下高亮由 VS Code 渲染，nvim 侧 highlighter 不可见，
      -- 不启动以省 CPU（parser 仍保留，flash 的 treesitter 选区需要）
      if not vim.g.vscode then
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("user_ts_start", { clear = true }),
          callback = function(args)
            if vim.treesitter.highlighter.active[args.buf] then
              return
            end
            pcall(vim.treesitter.start, args.buf)
          end,
        })
      end
    end,
  },

  -- telescope 模糊搜索
  {
    "nvim-telescope/telescope.nvim",
    cond = not vim.g.vscode,  -- VS Code 下用 quickOpen / findInFiles
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- C 实现的 fzf 排序器，模糊匹配速度提升 10 倍+
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      -- 文件 / 搜索
      { "<C-p>",      "<cmd>Telescope find_files<cr>",              desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",              desc = "Find files" },
      { "<leader>fF", function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find files (current dir)" },
      { "<leader>fa", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true, file_ignore_patterns = { "%.git/" } }) end, desc = "Find files (all, incl. ignored/hidden)" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles({ cwd_only = true }) end, desc = "Recent files (cwd)" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",               desc = "Live grep" },
      { "<leader>fg", function()
          local save_reg, save_type = vim.fn.getreg("v"), vim.fn.getregtype("v")
          vim.cmd('noautocmd normal! "vy')
          local text = vim.fn.getreg("v"):gsub("\n", " ")
          vim.fn.setreg("v", save_reg, save_type)
          require("telescope.builtin").grep_string({ search = text })
        end, mode = "x", desc = "Grep selection" },
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
    cond = not vim.g.vscode,  -- VS Code 下用自带资源管理器
    dependencies = { "nvim-mini/mini.icons" },
    keys = {
      { "tt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "tf", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
    },
    config = function()
      require("nvim-tree").setup({
        -- 不自动在树中定位当前文件；需要时用 tf 手动定位
        update_focused_file = { enable = false },
        view = {
          -- 自适应宽度：随最长文件名在 [30, 60] 区间内自动伸缩
          width = {
            min = 30,
            max = 60,
            padding = 1,
          },
        },
      })
    end,
  },

  -- 快捷键提示
  {
    "folke/which-key.nvim",
    cond = not vim.g.vscode,  -- 浮窗 UI 在 VS Code 下无法渲染
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- 安全关闭 buffer
  {
    "famiu/bufdelete.nvim",
    cond = not vim.g.vscode,  -- buffer 管理交给 VS Code 编辑器标签
    cmd = { "Bdelete", "Bwipeout" },
  },

  -- 自动补全括号
  {
    "windwp/nvim-autopairs",
    cond = not vim.g.vscode,  -- 插入模式由 VS Code 接管，自动配对用 VS Code 的
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

  -- 快速跳转（按 s 输入 2 字符，屏幕上出现字母标签直达）
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
        "s",
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

  -- TODO/FIXME/HACK 等注释高亮 + 检索
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
    },
  },

  -- 代码大纲侧栏（符号导航；LSP 优先，clangd 降级时回退 treesitter）
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Toggle outline (aerial)" },
    },
    opts = {
      -- backends 默认 {"lsp","treesitter",...}：clangd 可用时用 LSP 符号，否则回退 treesitter
      layout = { default_direction = "right", min_width = 30 },
      show_guides = true,
    },
  },
}
