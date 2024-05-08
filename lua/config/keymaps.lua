-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- "n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" }

-- Terminal
local lazyterm = function()
  LazyVim.terminal(nil, { cwd = LazyVim.root() })
end

vim.keymap.set("n", "<leader>ö", lazyterm, { desc = "Terminal (Root Dir)" })
vim.keymap.set("n", "<C-ö>", lazyterm, { desc = "Terminal (Root Dir)" }) -- TODO: why doesn't this work?

-- ChatGPT
vim.keymap.set("n", "<leader>gp", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })

-- Spectre
vim.keymap.set("n", "<leader>so", function()
  require("spectre").open_file_search({ select_word = true })
end, { desc = "Search in open files (Spectre)" })
