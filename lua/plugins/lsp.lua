-- LSP/诊断由 VS Code 提供，vscode-neovim 下全部禁用
if vim.g.vscode then
  return {}
end

-- server 名 (lspconfig) -> Mason 包名，避免两处手动同步
local servers = {
  lua_ls = "lua-language-server",
  pyright = "pyright",
  gopls = "gopls",
  ts_ls = "typescript-language-server",
  clangd = "clangd",
  rust_analyzer = "rust-analyzer",
  bashls = "bash-language-server",
}

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        go = { "golangcilint" },
        c = { "cppcheck" },
        cpp = { "cppcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    config = function()
      -- LSP server 之外的工具（formatter/linter），与 server 一并自动安装
      local tools = { "clang-format" }
      require("mason-tool-installer").setup({
        ensure_installed = vim.list_extend(vim.tbl_values(servers), tools),
        run_on_start = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { source = "if_many", header = "", prefix = "" },
        jump = { float = true },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(event)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gk", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        end,
      })

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- 只 enable 二进制已在 PATH 的 server，避免首次启动时 mason 还在下载
      local function enable_available()
        local available = {}
        for name, pkg in pairs(servers) do
          if vim.fn.executable(pkg) == 1 then
            table.insert(available, name)
          end
        end
        vim.lsp.enable(available)
      end
      enable_available()

      -- mason 首次补齐后再 enable 漏网的
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = enable_available,
      })
    end,
  },
}
