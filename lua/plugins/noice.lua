return {
  "folke/noice.nvim",
  enabled = true,
  opts = {
    lsp = {
      hover = {
        silent = true,
      },
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
