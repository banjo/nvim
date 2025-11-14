-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Sync buffers automatically
vim.opt.autoread = true

-- disable swap swapfile and showing error
vim.opt.swapfile = false

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

-- allow logging with :LspLog
-- vim.lsp.set_log_level("debug")

-- Need config for prettier
vim.g.lazyvim_prettier_needs_config = true

-- Make neovim-remote work
if vim.fn.has("nvim") == 1 and vim.fn.executable("nvr") == 1 then
  vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
end

-- fix error in volvo apps?
vim.opt.fixendofline = true

-- nice ui for diff view
vim.opt.diffopt = { "internal", "filler", "closeoff", "linematch:40" }

-- do not put ai in the cmp
vim.g.ai_cmp = false
