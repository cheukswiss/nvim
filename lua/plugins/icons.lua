-- 图标提供者：mini.icons（已完全取代 nvim-web-devicons）
-- 各插件依赖已全部改指向 mini.icons；这里 mock_nvim_web_devicons() 让仍调用
-- require("nvim-web-devicons") 的插件（lualine / bufferline / nvim-tree /
-- telescope / markview）透明走 mini.icons。
-- priority 调高 + lazy=false，确保它先于各 UI 插件完成 mock。
if vim.g.vscode then
  return {}
end

return {
  {
    "nvim-mini/mini.icons",
    version = false,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("mini.icons").setup(opts)
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
}
