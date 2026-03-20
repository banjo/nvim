-- local function determine_import_style()
--   local project_dir = vim.fn.getcwd()
--   local current_project_name = vim.fn.fnamemodify(project_dir, ":t")
--
--   local relative_import_projects = {
--     "unify-mono",
--   }
--
--   local import_style = "non-relative"
--
--   for _, project_name in ipairs(relative_import_projects) do
--     local lowercase_match = string.lower(current_project_name) == string.lower(project_name)
--     if lowercase_match then
--       import_style = "relative"
--       break
--     end
--   end
--
--   return import_style
-- end

-- Apply with function opts instead and the following settings for tsserver:
-- tspreferences = {
--   includeCompletionsForModuleExports = true,
--   includeCompletionsForImportStatements = true,
--   importModuleSpecifier = determine_import_style(),
--}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts = vim.tbl_deep_extend("force", opts, {
        inlay_hints = {
          enabled = false,
        },
        servers = {
          typos_lsp = {
            cmd_env = { RUST_LOG = "error" },
            init_options = {
              diagnosticSeverity = "Info", -- Set log level to "Info"
              config = "~/_typos.toml",
            },
          },
          vtsls = {
            settings = {
              typescript = {
                preferences = {
                  includeCompletionsForModuleExports = true,
                  includeCompletionsForImportStatements = true,
                  autoImportFileExcludePatterns = {
                    "@radix-ui/*",
                    "lucide-react",
                  },
                },
              },
            },
          },
          tsgo = false,
          -- tsgo = {
          --   init_options = {
          --     preferences = {
          --       includeCompletionsForModuleExports = true,
          --       includeCompletionsForImportStatements = true,
          --       autoImportFileExcludePatterns = {
          --         "@radix-ui/*",
          --         "lucide-react",
          --       },
          --     },
          --   },
          -- },
        },
      })

      if opts.servers and opts.servers.tsgo ~= false then
        vim.schedule(function()
          vim.notify("tsgo active")
        end)
      end

      return opts
    end,
  },
}
