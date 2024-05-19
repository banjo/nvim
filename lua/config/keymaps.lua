-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- "n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" }

-- General
vim.keymap.set("n", "<leader>fn", "<cmd>enew<CR>", { desc = "[f]ile [n]ew" })

vim.keymap.set("n", "<leader>ft", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fT", "<Nop>", { noremap = true, silent = true })

-- Terminal
-- vim.keymap.set("n", "<C-/>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-_>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-_>", ":ToggleTerm<CR>", { noremap = true, silent = true })

-- Navigation

-- Use % instead of | as | and _ is the same on some keyboards
vim.keymap.set("n", "<leader>w|", "<Nop>", { noremap = true, silent = true, desc = "" })
vim.keymap.set("n", "<leader>w%", "<C-W>v", { desc = "Split Window Right", remap = true, noremap = true })
vim.keymap.set("n", "<leader>%", "<C-W>v", { desc = "Split Window Right", remap = true, noremap = true })
vim.keymap.set("n", "<leader>|", "<Nop>", { noremap = true, silent = true, desc = "" })

-- vim-tmux-navigator
-- vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
-- vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- if os.getenv("TMUX") then
--   vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
--   vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
--   vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
--   vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
-- end

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

-- buffers
vim.keymap.set("n", "öb", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "äb", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- delete all buffers
vim.keymap.set("n", "<leader>ba", "<cmd>bufdo bd<cr>", { desc = "Delete all buffers" })

-- Quickfix
vim.keymap.set("n", "öq", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "äq", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "äd", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "öd", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "äe", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "öe", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "äw", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "öw", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
