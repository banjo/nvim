-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- "n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" }

-- General
vim.keymap.set("n", "<leader>fn", "<cmd>enew<CR>", { desc = "[f]ile [n]ew" })

vim.keymap.set("n", "<leader>ft", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fT", "<Nop>", { noremap = true, silent = true })

-- Guess indentation based on the file
vim.keymap.set("n", "<leader>ci", "<cmd>GuessIndent<CR>", { desc = "[c]ode [i]ndentation" })

-- set filetype=json
vim.keymap.set("n", "<leader>ftj", "<cmd>set ft=json<CR>", { desc = "[f]ile [t]ype [j]son" })

-- Remove one character without yanking
vim.keymap.set("n", "x", '"x')

-- git
-- vim.keymap.set("n", "<leader>gB", "<Nop>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "lazy[g]it" })
vim.keymap.set("n", "<leader>gG", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gb", Snacks.git.blame_line, { desc = "[g]it [b]lame line" })
vim.keymap.set("n", "<leader>gf", function()
  local git_path = vim.api.nvim_buf_get_name(0)
  Snacks.lazygit({ args = { "-f", vim.trim(git_path) } })
end, { desc = "lazy[g]it [f]ile history" })

vim.keymap.set("n", "<leader>gl", function()
  Snacks.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
end, { desc = "lazy[g]it [l]og" })
vim.keymap.set("n", "<leader>gL", "<Nop>", { noremap = true, silent = true })

-- reload lsp
vim.keymap.set("n", "<leader>rl", "<cmd>LspRestart<CR>", { desc = "[r]estart lsp" })

-- Terminal
-- vim.keymap.set("n", "<C-/>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-_>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-_>", function()
  Snacks.terminal()
end, { noremap = true, silent = true })

-- Navigation
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })

-- grug-far
vim.keymap.set("n", "<leader>sR", function()
  local grug = require("grug-far")
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })
end, {
  desc = "[s]earch [R]eplace (grug-far)",
})

vim.keymap.set("n", "<leader>sf", function()
  local grug = require("grug-far")
  grug.open({
    transient = true,
    prefills = {
      filesFilter = vim.fn.expand("%:t"), -- Filename of the current file
      paths = vim.fn.expand("%:p:h"), -- Path to the current file's directory
    },
  })
end, { desc = "[s]earch [f]ile (grug-far)" })

-- Telescope
vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
end, { noremap = true, silent = true, desc = "Smart open" })

-- set resume here as it needs to override spectre
vim.keymap.set(
  "n",
  "<leader>sr",
  "<cmd>Telescope resume<cr>",
  { noremap = true, silent = true, desc = "[s]earch [r]esume" }
)

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

-- Diffviews
vim.keymap.set("n", "<leader>gd", function()
  local views = require("diffview.lib").views
  if next(views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("tabc")
  end
end, { desc = "toggle [d]iffview" })

vim.keymap.set("n", "<leader>gH", function()
  local views = require("diffview.lib").views
  if next(views) == nil then
    vim.cmd("DiffviewFileHistory %")
  else
    vim.cmd("tabc")
  end
end, { desc = "toggle git [H]istory" })

vim.keymap.set("n", "<leader>gx", "<cmd>tabc<CR>", { desc = "close diffview" })

-- Noice
vim.keymap.set("n", "<leader>xn", "<cmd>Noice<CR>", { desc = "[n]oice messages" })
vim.keymap.set("n", "<leader>xe", "<cmd>NoiceErrors<CR>", { desc = "noice [e]rrors" })

-- treewalker (with iterm2)
vim.api.nvim_set_keymap("n", "˛", ":Treewalker Left<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "√", ":Treewalker Down<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ª", ":Treewalker Up<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ﬁ", ":Treewalker Right<CR>", { noremap = true, silent = true })

-- Define the function to show key press
local function showKeyPress()
  local char = vim.fn.nr2char(vim.fn.getchar())
  print("Last key pressed: " .. char)
end

-- Map a key to call this function in normal mode
vim.api.nvim_set_keymap("n", "<F3>", "", { noremap = true, callback = showKeyPress })

-- Run eslint fix all with command
vim.keymap.set("n", "<leader>ce", "<cmd>:EslintFixAll<CR>", { desc = "[e]slintFixAll" })
