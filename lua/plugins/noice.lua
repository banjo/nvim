return {
  "folke/noice.nvim",
  enabled = true,
  opts = {
    lsp = {
      signature = {
        auto_open = {
          enabled = false,
        },
      },
    },
    presets = {
      -- borders on lsp signature (hover) window
      lsp_doc_border = true,
    },
  },
}
