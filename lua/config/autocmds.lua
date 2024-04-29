-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable auto-comment for new lines
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- Remove 'o' and 'r' from formatoptions for all file types
    vim.opt.formatoptions:remove("o")
    vim.opt.formatoptions:remove("r")
  end,
})
