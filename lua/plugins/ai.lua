-- AI 助手（对话/行内重构/agent），与 minuet 的行内补全互补。
-- 复用 .env 的 DEEPSEEK_API_KEY：codecompanion 内置 deepseek adapter 默认读该环境变量，
-- 而该变量已由 config/env.lua 在启动时注入 vim.env，故无需额外接线。
if vim.g.vscode then
  return {}
end

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",      mode = { "n", "v" }, desc = "AI: Actions palette" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",  mode = { "n", "v" }, desc = "AI: Toggle chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>",             mode = { "n", "v" }, desc = "AI: Inline prompt" },
      { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>",     mode = "v",          desc = "AI: Add selection to chat" },
    },
    opts = {
      adapters = {
        http = {
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              schema = { model = { default = "deepseek-v4-pro" } },
            })
          end,
        },
      },
      strategies = {
        chat = { adapter = "deepseek" },
        inline = { adapter = "deepseek" },
        cmd = { adapter = "deepseek" },
      },
    },
  },
}
