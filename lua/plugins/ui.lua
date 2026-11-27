-- UI 由 VS Code 渲染，vscode-neovim 下全部禁用
if vim.g.vscode then
  return {}
end

return {
  -- colorscheme
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        color_overrides = { vscBack = "#141414" },
      })
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-mini/mini.icons", "stevearc/aerial.nvim" },
    config = function()
      local function macro_recording()
        local reg = vim.fn.reg_recording()
        return reg == "" and "" or "recording @" .. reg
      end

      -- local function clipboard_provider()
      --   local cb = vim.g.clipboard
      --   return type(cb) == "table" and cb.name or ""
      -- end

      require("lualine").setup({
        options = { theme = "vscode", globalstatus = true },
        sections = {
          lualine_c = { "filename", "aerial" },
          lualine_x = {
            "searchcount",
            "selectioncount",
            macro_recording,
            -- clipboard_provider,
            "lsp_status",
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      })

      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        callback = function()
          vim.schedule(function()
            require("lualine").refresh({ place = { "statusline" } })
          end)
        end,
      })
    end,
  },

  -- Buffer 标签栏
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-mini/mini.icons" },
    event = "VeryLazy",
    config = function()
      -- 标签栏配色：bufferline 有约 60 个高亮组，且有些组只在特定状态下出现
      -- （有诊断、已修改、同名文件……），逐个手写 bg 必然漏组、出现色块。
      -- 这里遍历全部默认组统一刷底色，再单独调整少数组的前景色。
      local c = {
        bar = "#2B3038", -- 标签栏与非当前标签共用，整条连成一体
        sel = "#1F3A5F", -- 当前标签：深蓝，保证各文件类型图标的原色看得清
        fg = "#B8BEC9",
        sel_fg = "#FFFFFF",
        divider = "#3E4451", -- 标签间细分隔线，只比底色略亮
        accent = "#4FC1FF", -- 当前标签左侧指示条
        error = "#F48771",
        warning = "#CCA700",
        modified_sel = "#FFD21A",
      }

      local bufferline = require("bufferline")
      bufferline.setup({
        options = {
          numbers = "ordinal",
          style_preset = bufferline.style_preset.no_italic,
          -- vscode 主题直接定义了 BufferLineFill / IndicatorSelected，不关掉的话主题会盖过下面的配色
          themable = false,
          truncate_names = false,
          show_buffer_close_icons = false,
          tab_size = 1,
          diagnostics = "nvim_lsp",
          -- 图标取自 lsp.lua 的 vim.diagnostic.config signs，三处（符号栏/标签栏/状态栏）只维护一份
          diagnostics_indicator = function(_, _, counts)
            local icons = vim.diagnostic.config().signs.text
            local s = ""
            if counts.error then
              s = s .. " " .. icons[vim.diagnostic.severity.ERROR] .. " " .. counts.error
            end
            if counts.warning then
              s = s .. " " .. icons[vim.diagnostic.severity.WARN] .. " " .. counts.warning
            end
            return s
          end,
          close_command = "Bdelete %d",
          right_mouse_command = "Bdelete %d",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "NvimTreeNormal", -- 与下方文件树同底色
              separator = true,
            },
          },
        },
        highlights = function(defaults)
          local hl = {}
          for name in pairs(defaults.highlights) do
            local selected = name:match("_selected$") ~= nil
            hl[name] = {
              fg = selected and c.sel_fg or c.fg,
              bg = selected and c.sel or c.bar,
              bold = selected or nil,
            }
          end

          -- 后续只改前景色，底色统一沿用上面的循环
          local function tint(names, fg, bold)
            for _, name in ipairs(names) do
              hl[name].fg = fg
              hl[name].bold = bold
            end
          end

          -- 分隔线：只留一条比底色略亮的细线
          tint({ "separator", "separator_visible", "separator_selected", "offset_separator", "tab_separator", "tab_separator_selected" }, c.divider)
          tint({ "indicator_visible" }, c.bar)
          tint({ "indicator_selected" }, c.accent)
          -- 诊断计数着色；文件名本身不随诊断变色
          tint({ "error_diagnostic", "error_diagnostic_visible", "error_diagnostic_selected" }, c.error, true)
          tint({ "warning_diagnostic", "warning_diagnostic_visible", "warning_diagnostic_selected" }, c.warning, true)
          tint({ "modified", "modified_visible" }, c.warning)
          tint({ "modified_selected" }, c.modified_sel)
          -- :BufferLinePick 的跳转字母保持醒目
          tint({ "pick", "pick_visible", "pick_selected" }, c.error, true)
          return hl
        end,
      })
    end,
  },

  -- 缩进参考线
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup()
    end,
  },

  -- 右上角通知弹窗：渲染样式与动画（noice 会把通知路由到这里）
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "fade_in_slide_out",
      render = "default",
      timeout = 3000,
      top_down = true,
      max_width = 60,
      background_colour = "#141414",
    },
  },

  -- 命令行浮窗 + 通知接管（noice：cmdline 居中浮窗；通知转交 nvim-notify）
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      cmdline = { enabled = true, view = "cmdline_popup" },
      -- view_search 默认把搜索计数以虚拟文本贴在光标行尾，抢眼且挤占正文，
      -- 关掉后交给 lualine 的 searchcount 组件在状态栏显示。
      messages = { enabled = true, view_search = false },
      notify = { enabled = true },
      popupmenu = { enabled = true },
      lsp = { progress = { enabled = false } },
      presets = { command_palette = true },
    },
  },
}
