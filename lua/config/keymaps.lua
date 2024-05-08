-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- "n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" }

-- Terminal
local lazyterm = function()
  LazyVim.terminal(nil, { cwd = LazyVim.root() })
end

vim.keymap.set("n", "<leader>ö", lazyterm, { desc = "terminal" })
vim.keymap.set("n", "<C-ö>", lazyterm, { desc = "terminal" }) -- TODO: why doesn't this work?

-- ChatGPT
vim.keymap.set("n", "<leader>gp", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })

-- Spectre
vim.keymap.set("n", "<leader>so", function()
  require("spectre").open_file_search({ select_word = true })
end, { desc = "[s]earch [o]pen files (spectre)" })
vim.keymap.set("n", "<leader>sr", '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "[s]earch [r]eplace (spectre)",
})

-- Telescope
vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
end, { noremap = true, silent = true, desc = "Smart open" })

vim.keymap.set("n", "<C-p>", function()
  require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
end, { noremap = true, silent = true, desc = "Smart open" })
