-- 插入模式与补全由 VS Code 接管，vscode-neovim 下禁用
if vim.g.vscode then
  return {}
end

return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  -- AI 补全：minuet-ai 接 DeepSeek（FIM），以 ghost text 行内灰字展示。
  -- API key 由 config/env.lua 从 .env 读取。
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    config = function()
      require("minuet").setup({
        -- FIM 端点，非推理路径，延迟低、适合 ghost text
        provider = "openai_fim_compatible",
        request_timeout = 5,
        virtualtext = {
          auto_trigger_ft = { "*" },
          show_on_completion_menu = true, -- blink 菜单可见时也显示灰字，否则会被抑制
          keymap = {
            accept = "<C-l>",
            accept_line = "<C-j>",
            prev = "<M-[>",
            next = "<M-]>",
            dismiss = "<M-e>", -- 避开 blink 的 <C-e>
          },
        },
        provider_options = {
          openai_fim_compatible = {
            api_key = "DEEPSEEK_API_KEY",
            name = "deepseek",
            end_point = "https://api.deepseek.com/beta/completions",
            model = "deepseek-v4-pro",
            optional = {
              max_tokens = 128,
            },
          },
        },
      })
    end,
  },
}
