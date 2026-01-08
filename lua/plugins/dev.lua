local lazy_config = require("lazy.core.config")
local DEV_PATH = lazy_config.options.dev.path

local function should_use_dev(plugin_name)
  local full_path = vim.fn.expand(DEV_PATH .. "/" .. plugin_name)
  return vim.fn.isdirectory(full_path) == 1
end

return {
  {
    "banjo/contextfiles.nvim",
    dev = should_use_dev("contextfiles.nvim"),
  },
  {
    "banjo/package-pilot.nvim",
    dev = should_use_dev("package-pilot.nvim"),
  },
}
