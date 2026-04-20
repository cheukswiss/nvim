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
}
