-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- "n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" }

-- General
vim.keymap.set("n", "<leader>fn", "<cmd>enew<CR>", { desc = "[f]ile [n]ew" })

vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

-- Paste without overwriting the default register
vim.keymap.set("x", "p", '"_dP', { noremap = true, silent = true })

-- Guess indentation based on the file
vim.keymap.set("n", "<leader>ci", "<cmd>GuessIndent<CR>", { desc = "[c]ode [i]ndentation" })

-- remove boring ones
vim.keymap.del("n", "<leader>K")

-- set filetype=json
vim.keymap.set("n", "<leader>ftj", "<cmd>set ft=json<CR>", { desc = "[f]ile [t]ype [j]son" })

-- set filetype with telescope picker
vim.keymap.set("n", "<leader>ftc", function()
  local filetypes = {
    { name = "lua", filetype = "lua" },
    { name = "javascript", filetype = "javascript" },
    { name = "typescript", filetype = "typescript" },
    { name = "python", filetype = "python" },
    { name = "go", filetype = "go" },
    { name = "rust", filetype = "rust" },
    { name = "java", filetype = "java" },
    { name = "c", filetype = "c" },
    { name = "c++", filetype = "cpp" },
    { name = "html", filetype = "html" },
    { name = "css", filetype = "css" },
    { name = "markdown", filetype = "markdown" },
    { name = "json", filetype = "json" },
    { name = "yaml", filetype = "yaml" },
    { name = "toml", filetype = "toml" },
    { name = "xml", filetype = "xml" },
    { name = "sql", filetype = "sql" },
    { name = "bash", filetype = "bash" },
    { name = "sh", filetype = "sh" },
    { name = "zsh", filetype = "zsh" },
  }

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Select Filetype",
      finder = require("telescope.finders").new_table({
        results = filetypes,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.bo.filetype = selection.value.filetype
          vim.notify("Set filetype to " .. selection.value.name, vim.log.levels.INFO)
        end)
        return true
      end,
    })
    :find()
end, { desc = "[f]ile [t]ype [c]ustom" })

-- Remove one character without yanking
vim.keymap.set("n", "x", '"x')

-- git
-- vim.keymap.set("n", "<leader>gB", "<Nop>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "lazy[g]it" })
vim.keymap.del("n", "<leader>gG")
vim.keymap.set("n", "<leader>gb", Snacks.git.blame_line, { desc = "[g]it [b]lame line" })
vim.keymap.set("n", "<leader>gf", function()
  local git_path = vim.api.nvim_buf_get_name(0)
  Snacks.lazygit({ args = { "-f", vim.trim(git_path) } })
end, { desc = "lazy[g]it [f]ile history" })

vim.keymap.set("n", "<leader>gl", function()
  Snacks.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
end, { desc = "lazy[g]it [l]og" })
vim.keymap.del("n", "<leader>gL")

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

-- Find related files (e.g., Service.ts -> Service.test.ts, Service.mock.ts)
vim.keymap.set("n", "<leader>fo", function()
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.expand("%:p:h")
  local file_name = vim.fn.expand("%:t:r") -- gets the filename without extension

  -- Extract base file name (handle names like "Service.mock" -> "Service")
  local base_name = file_name
  local parts = vim.split(file_name, "%.")
  if #parts > 1 then
    base_name = parts[1]
  end

  local function find_related_files()
    -- NOT BEST SOLUTION BUT WORKS FOR NOW
    local current_dir_with_2_last_folders_removed = vim.fn.fnamemodify(current_dir, ":h:h")
    local pattern = current_dir_with_2_last_folders_removed .. "/**/" .. base_name .. ".*"
    local files = vim.fn.glob(pattern, false, true)

    local related_files = {}
    local seen_files = {}

    for _, file in ipairs(files) do
      local normalized_file = vim.fn.fnamemodify(file, ":p")
      if normalized_file ~= current_file and not seen_files[normalized_file] then
        table.insert(related_files, file)
        seen_files[normalized_file] = true
      end
    end

    return related_files
  end

  local related_files = find_related_files()

  if #related_files == 0 then
    vim.notify("No related files found", vim.log.levels.INFO)
    return
  end

  if #related_files == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(related_files[1]))
    return
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Related Files",
      finder = require("telescope.finders").new_table({
        results = related_files,
        entry_maker = function(entry)
          local relative_path = vim.fn.fnamemodify(entry, ":~:.")
          return {
            value = entry,
            display = relative_path,
            ordinal = relative_path,
          }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd("edit " .. vim.fn.fnameescape(selection.value))
        end)
        return true
      end,
    })
    :find()
end, { desc = "[f]iles [o]ther (related)" })

vim.keymap.set("n", "<leader>R", function()
  local plugins = require("lazy").plugins()
  local loader = require("lazy.core.loader")

  local total = 0
  for _, plugin in ipairs(plugins) do
    if plugin.dev == true then
      loader.reload(plugin.name)
      total = total + 1
    end
  end

  local str = "Reloaded " .. total .. " plugins"
  vim.notify(str, vim.log.levels.INFO)
end, { desc = "reload dev plugins", remap = true, noremap = true })
