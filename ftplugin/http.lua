-- Code for setting up keymaps for kulala rest client
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<CR>",
  "<cmd>lua require('kulala').run()<cr>",
  { noremap = true, silent = true, desc = "Execute Request" }
)

-- Jump to the next and previous request
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "k[",
  "<cmd>lua require('kulala').jump_prev()<cr>",
  { noremap = true, silent = true, desc = "Previous Request" }
)
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "k]",
  "<cmd>lua require('kulala').jump_next()<cr>",
  { noremap = true, silent = true, desc = "Next Request" }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>ki",
  "<cmd>lua require('kulala').inspect()<cr>",
  { noremap = true, silent = true, desc = "Inspect Request" }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>kt",
  "<cmd>lua require('kulala').toggle_view()<cr>",
  { noremap = true, silent = true, desc = "Toggle Body/Headers" }
)
