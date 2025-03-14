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
  pattern = { ".env*", "*.md" },
  group = group,
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

-- Run eslint on save for ts and js files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    local eslint_config_files =
      { ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", "eslint.config.js" }
    local function eslint_installed()
      for _, config_file in ipairs(eslint_config_files) do
        if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. config_file) == 1 then
          return true
        end
      end
      return false
    end

    if eslint_installed() then
      vim.cmd("EslintFixAll")
    end
  end,
})

-- Format buffer when inline request is complete in CodeCompanion
local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionInline*",
  group = group,
  callback = function(request)
    if request.match == "CodeCompanionInlineFinished" then
      require("conform").format({ bufnr = request.buf })
    end
  end,
})

-- Enable csv view whenever a csv file is opened
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.csv",
  callback = function()
    vim.cmd("CsvViewEnable")
  end,
})

-- close diffview with "q"
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "DiffviewFiles", "DiffviewFileHistory" }, -- The filetypes diffview.nvim uses for its buffers
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":tabc<CR>", {
      noremap = true,
      silent = true,
      desc = "Close DiffView tab",
    })
  end,
})

-- close codecompanion with "q" in normal mode
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "codecompanion", "CodeCompanion" },  -- Try both capitalizations
--   callback = function()
--     vim.keymap.set("n", "q", ":close<CR>", {
--       noremap = true,
--       silent = true,
--       desc = "Close codecompanion buffer",
--       buffer = 0,  -- Apply to current buffer only
--     })
--   end,
-- })

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    local buftype = vim.bo.filetype
    if buftype == "codecompanion" or buftype == "CodeCompanion" then
      vim.keymap.set("n", "q", ":close<CR>", {
        noremap = true,
        silent = true,
        buffer = 0,
        desc = "Close codecompanion buffer",
      })
    end
  end,
})
