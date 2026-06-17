-- 加载 .env 环境变量（API key 等），需在插件初始化前
require("config.env").load()

-- 基础设置
require("config.options")

-- 键位映射配置
require("config.keymaps")

-- 自动命令
require("config.autocmds")

-- 插件管理
require("config.lazy")
