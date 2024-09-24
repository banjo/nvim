local keys = require("lazy.core.handler.keys")
return {
  "princejoogie/dir-telescope.nvim",
  -- telescope.nvim is a required dependency
  requires = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("dir-telescope").setup({
      -- these are the default options set
      hidden = true,
      no_ignore = false,
      show_preview = true,
      follow_symlinks = false,
    })

    require("telescope").load_extension("dir")
  end,
}
