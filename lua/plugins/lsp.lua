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
  jsonls = "json-lsp",
  yamlls = "yaml-language-server",
  cssls = "css-lsp",
  html = "html-lsp",
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
    opts = function()
      -- prettier 覆盖前端系：只跑第一个可用的（prettierd 优先，回退 prettier）
      local prettier = { "prettierd", "prettier", stop_after_first = true }
      return {
        formatters_by_ft = {
          c = { "clang-format" },
          cpp = { "clang-format" },
          css = prettier,
          scss = prettier,
          less = prettier,
          html = prettier,
          json = prettier,
          jsonc = prettier,
          yaml = prettier,
          markdown = prettier,
          javascript = prettier,
          javascriptreact = prettier,
          typescript = prettier,
          typescriptreact = prettier,
        },
        -- 仅当项目存在 prettier 配置时才启用 prettier；
        -- 无配置 → prettier 视为不可用 → <leader>cf 的 lsp_format=fallback 回退 LSP 中性格式化
        formatters = {
          prettierd = { require_cwd = true },
          prettier = { require_cwd = true },
        },
      }
    end,
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
      -- linter 名与 nvim-lint linters_by_ft 保持一致，避免两份清单漂移
      local tools = {
        "clang-format",   -- conform: c/cpp
        "prettierd",      -- conform: 前端系（json/yaml/css/html/md/js/ts）
        "prettier",       -- conform: prettierd 回退
        "shellcheck",     -- nvim-lint: sh/bash
        "ruff",           -- nvim-lint: python
        "eslint_d",       -- nvim-lint: javascript/typescript
        "golangci-lint",  -- nvim-lint: go
      }
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
      { "b0o/SchemaStore.nvim", lazy = true, version = false },
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
          map("n", "gh", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")

          -- inlay hints（参数名/类型等）：服务端支持就开启，<leader>th 切换
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
                { bufnr = event.buf }
              )
            end, "Toggle inlay hints")
          end
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

      -- json/yaml：SchemaStore 提供 schema 校验/补全；
      -- LSP 自带格式化保持默认开启，作为项目无 prettier 配置时的中性回退
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      -- mason 包名 ≠ 可执行名的 server（vscode 系），enable 前据此查 PATH
      local server_bin = {
        jsonls = "vscode-json-language-server",
        cssls = "vscode-css-language-server",
        html = "vscode-html-language-server",
      }

      -- 只 enable 二进制已在 PATH 的 server，避免首次启动时 mason 还在下载
      local function enable_available()
        local available = {}
        for name, pkg in pairs(servers) do
          if vim.fn.executable(server_bin[name] or pkg) == 1 then
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
