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
      opts.servers.vtsls.settings.typescript = {
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifier = "non-relative",
          -- autoImportFileExcludePatterns = {
          --   "dist/*",
          --   "@radix-ui/*",
          --   "lucide-react",
          -- },
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
