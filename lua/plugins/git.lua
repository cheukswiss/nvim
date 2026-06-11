-- git 状态/diff 由 VS Code 提供，vscode-neovim 下禁用
if vim.g.vscode then
  return {}
end

return {
  -- git 状态标记与 hunk 操作
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      current_line_blame_opts = { delay = 500 }, -- 默认 1000 太慢
      preview_config = { border = "rounded" },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        -- ── Hunk 导航（遵循 vim diff 约定，不占 leader 空间）─────────
        -- 在 diff 模式下 fallthrough 到 vim 原生 ]c/[c，避免和 gitsigns 冲突
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev hunk")

        -- ── Hunk 操作（前缀 <leader>i）──────────────────────────────
        map("n", "<leader>ip", gs.preview_hunk,    "Preview hunk")
        map("n", "<leader>is", gs.stage_hunk,      "Stage hunk")
        map("n", "<leader>ir", gs.reset_hunk,      "Reset hunk")
        map("v", "<leader>is", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        map("v", "<leader>ir", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")
        map("n", "<leader>iS", gs.stage_buffer,    "Stage buffer")
        map("n", "<leader>iR", gs.reset_buffer,    "Reset buffer")
        map("n", "<leader>iu", gs.undo_stage_hunk, "Undo stage hunk")

        -- ── Blame ──────────────────────────────────────────────────
        map("n", "<leader>ib", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>iB", gs.toggle_current_line_blame, "Toggle line blame")

        -- ── Diff ───────────────────────────────────────────────────
        map("n", "<leader>id",  gs.diffthis,                     "Diff this")
        map("n", "<leader>iD",  function() gs.diffthis("~") end, "Diff this vs HEAD~")
        map("n", "<leader>itd", gs.toggle_deleted,               "Toggle deleted lines")

        -- ── Text object: ih = inside hunk ──────────────────────────
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },
}
