-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Sync buffers automatically
vim.opt.autoread = true

-- disable swap swapfile and showing error
vim.opt.swapfile = false

-- Change local leader for grug far
vim.g.maplocalleader = ","

-- Set filetype for .http files
vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

-- No animations
vim.g.snacks_animate = false

-- Use nvim with plguins from lazyvim
-- vim.g.lazyvim_cmp = "nvim-cmp"
