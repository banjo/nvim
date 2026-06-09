return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      heading = {
        enabled = false,
      },
    },
  },

  -- Disable markdownlint-cli2 as a conform formatter for markdown files.
  -- It resets ordered list numbering (2. 3. 4. -> 1. 1. 1.) when code blocks
  -- appear between list items, because MD029 defaults to style "one".
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "markdown-toc" },
        ["markdown.mdx"] = { "markdown-toc" },
      },
    },
  },
}
