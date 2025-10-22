return {
  "axelvc/template-string.nvim",
  opts = {
    filetypes = {
      "html",
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
      "vue",
      "svelte",
      "python",
      "cs",
    },
    jsx_brackets = true,
    remove_template_string = false,
    restore_quotes = {
      normal = [["]],
      jsx = [["]],
    },
  },
  event = "VeryLazy",
}
