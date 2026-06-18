-- 加载 .env 到环境变量：Neovim 不会自动读取 .env，这里把 KEY=VALUE 写入
-- vim.env 使其对 os.getenv 可见（minuet 等插件靠它拿 API key）。
local M = {}

function M.load()
  local path = vim.fn.stdpath("config") .. "/.env"
  local fd = io.open(path, "r")
  if not fd then
    return
  end
  for line in fd:lines() do
    -- 仅匹配 KEY=VALUE（容许行首空格）；空行、注释、畸形行自然不匹配而跳过
    local key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)$")
    if key then
      -- 去行尾空白与 CRLF 的 \r（WSL 下 .env 若存成 CRLF 会带尾随 \r）
      value = value:gsub("%s+$", "")
      -- 去掉成对的首尾引号（两端须为同一种引号才剥，避免误删单侧引号）
      value = value:gsub("^(['\"])(.*)%1$", "%2")
      -- 已存在的环境变量优先（外部 export 可覆盖 .env）
      vim.env[key] = vim.env[key] or value
    end
  end
  fd:close()
end

return M
