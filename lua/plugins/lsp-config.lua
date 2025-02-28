return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        vtsls = {
          settings = {
            typescript = {
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
            },
          },
        },
      },
      setup = {
        eslint = function()
          -- This is needed to remove the error with eslint (sohuld work after nvim 0.11)
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
}
