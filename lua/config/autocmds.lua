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
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
--   callback = function()
--     -- List of repo names where ESLint should NOT run on save
--     local excluded_repos = {}
--
--     local cwd = vim.fn.getcwd()
--     local repo_name = vim.fn.fnamemodify(cwd, ":t")
--
--     for _, excluded in ipairs(excluded_repos) do
--       if repo_name == excluded then
--         return
--       end
--     end
--
--     local eslint_config_files =
--       { ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", "eslint.config.js" }
--     local function eslint_installed()
--       for _, config_file in ipairs(eslint_config_files) do
--         if vim.fn.filereadable(cwd .. "/" .. config_file) == 1 then
--           return true
--         end
--       end
--       return false
--     end
--
--     if eslint_installed() then
--       vim.cmd("EslintFixAll")
--     end
--   end,
-- })

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
        desc = "Close CodeCompanion Buffer",
      })
    end
  end,
})

vim.api.nvim_create_user_command("CopyOpenBuffers", function()
  local result = {}
  table.insert(
    result,
    "> This markdown contains the contents of all open buffers in Neovim. Each buffer is shown as a section with its name and contents."
  )
  table.insert(result, "")
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
      local name = vim.api.nvim_buf_get_name(bufnr)
      local fname
      if name == "" then
        fname = string.format("unnamed-%d", bufnr)
      else
        fname = vim.fn.fnamemodify(name, ":t")
      end
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      table.insert(result, string.format("## %s", fname))
      table.insert(result, "```")
      for _, line in ipairs(lines) do
        table.insert(result, line)
      end
      table.insert(result, "```")
      table.insert(result, "") -- blank line between buffers
    end
  end
  local text = table.concat(result, "\n")
  vim.fn.setreg("+", text)
  vim.notify("Copied all open buffers to clipboard in Markdown format!", vim.log.levels.INFO)
end, {})

-- Stop language servers when this nvim has been unfocused for a while (e.g. another
-- tmux workspace is active) to free memory, and start them again on focus.
-- Needs `focus-events on` in tmux.
local lsp_idle_group = vim.api.nvim_create_augroup("lsp_idle_stop", { clear = true })
local lsp_idle_timer = assert(vim.uv.new_timer())
local lsp_stopped_for_idle = false

vim.api.nvim_create_autocmd("FocusLost", {
  group = lsp_idle_group,
  callback = function()
    local minutes = vim.g.lsp_idle_stop_minutes or 10
    lsp_idle_timer:start(
      math.floor(minutes * 60 * 1000),
      0,
      vim.schedule_wrap(function()
        local clients = vim.lsp.get_clients()
        if #clients == 0 then
          return
        end
        for _, client in ipairs(clients) do
          client:stop()
        end
        lsp_stopped_for_idle = true
      end)
    )
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  group = lsp_idle_group,
  callback = function()
    lsp_idle_timer:stop()
    if lsp_stopped_for_idle then
      lsp_stopped_for_idle = false
      -- Re-runs only nvim's LSP attach autocmd for every buffer, not ftplugins
      pcall(vim.cmd.doautoall, "nvim.lsp.enable FileType")
    end
  end,
})
