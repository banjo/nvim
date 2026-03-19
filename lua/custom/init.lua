local custom_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "custom")

local function load_custom_scripts()
  local ok, iterator = pcall(vim.fs.dir, custom_dir)
  if not ok then
    return
  end

  for name, type_ in iterator do
    if type_ == "file" and name:sub(-4) == ".lua" and name ~= "init.lua" then
      local module_name = name:gsub("%.lua$", "")
      pcall(require, "custom." .. module_name)
    end
  end
end

load_custom_scripts()
