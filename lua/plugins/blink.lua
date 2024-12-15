return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap = { preset = "super-tab", ["<CR>"] = { "accept", "fallback" } }
    opts.completion = {
      menu = {
        border = "rounded",
        auto_show = true,
      },
      documentation = {
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = false,
      },
    }
    opts.sources.default = { "copilot", "lsp", "path" }
  end,
}
