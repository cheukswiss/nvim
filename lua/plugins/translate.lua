if vim.g.vscode then
  return {}
end

return {
  {
    "potamides/pantran.nvim",
    cmd = "Pantran",
    keys = {
      { "<leader>tt", "<cmd>Pantran<cr>", mode = { "n", "v" }, desc = "Translate: interactive window" },
      {
        "<leader>tr",
        function() return require("pantran").motion_translate() end,
        mode = { "n", "x" },
        expr = true,
        desc = "Translate: motion / selection",
      },
      {
        "<leader>trr",
        function() return require("pantran").motion_translate() .. "_" end,
        mode = "n",
        expr = true,
        desc = "Translate: current line",
      },
    },
    config = function()
      require("pantran").setup({
        default_engine = "google",
        engines = {
          google = {
            fallback = {
              default_source = "auto",
              default_target = "zh-CN",
            },
          },
        },
      })
    end,
  },
}
