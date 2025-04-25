local function determine_import_style()
  local project_dir = vim.fn.getcwd()
  local current_project_name = vim.fn.fnamemodify(project_dir, ":t")

  local relative_import_projects = {
    "unify-mono",
  }

  local import_style = "non-relative"

  for _, project_name in ipairs(relative_import_projects) do
    local lowercase_match = string.lower(current_project_name) == string.lower(project_name)
    if lowercase_match then
      import_style = "relative"
      break
    end
  end

  return import_style
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- disable default K, and use timestamp preview instead
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false }

      -- Set inlay hints
      opts.inlay_hints = opts.inlay_hints or {}
      opts.inlay_hints.enabled = false

      -- Configure servers (be specific to not mess with other settings)
      opts.servers = opts.servers or {}
      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls.settings = opts.servers.vtsls.settings or {}

      -- Add typos-lsp to the servers table
      opts.servers.typos_lsp = {
        cmd_env = { RUST_LOG = "error" },
        init_options = {
          diagnosticSeverity = "Info", -- Set log level to "Info"
        },
      }

      local import_style = determine_import_style()
      vim.notify("Import style: " .. import_style, vim.log.levels.INFO, { title = "LSP" })

      opts.servers.vtsls.settings.typescript = {
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifier = import_style,
          autoImportFileExcludePatterns = {
            "@radix-ui/*",
            "lucide-react",
          },
        },
      }
      --
      -- Configure setup functions
      opts.setup = opts.setup or {}
      opts.setup.eslint = function()
        -- This is needed to remove the error with eslint (should work after nvim 0.11)
        require("lazyvim.util").lsp.on_attach(function(client)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end
    end,
  },
}
