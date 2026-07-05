if vim.g.vscode then
  return {}
end

return {
  {
    "3rd/image.nvim",
    build = false,
    lazy = false,
    opts = {
      backend = "sixel",
      processor = "magick_cli",
      integrations = {
        markdown = { enabled = false },
        asciidoc = { enabled = false },
        neorg = { enabled = false },
        rst = { enabled = false },
        typst = { enabled = false },
      },
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.bmp" },
    },
  },
}
