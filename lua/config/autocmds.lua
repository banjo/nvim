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

-- Go to next match
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local buffer = vim.api.nvim_get_current_buf()

    local function goto_next_match()
      require("illuminate")["goto_next_reference"](true)
    end

    local function goto_prev_match()
      require("illuminate")["goto_prev_reference"](true)
    end

    vim.keymap.set("n", "ää", function()
      require("illuminate")["goto_next_reference"](true)
    end, {
      desc = "Next Reference",
      buffer = buffer,
    })
    vim.keymap.set("n", "öö", function()
      require("illuminate")["goto_prev_reference"](true)
    end, {
      desc = "Previous Reference",
      buffer = buffer,
    })
  end,
})

-- Disable diagnostics for .env and .md files
local group = vim.api.nvim_create_augroup("__nofilediagnostics", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { ".env", "*.md" },
  group = group,
  callback = function(args)
    vim.diagnostic.disable(args.buf)
  end,
})
