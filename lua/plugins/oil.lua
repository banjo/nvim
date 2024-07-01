return {
  {
    "stevearc/oil.nvim",
    opts = {
      win_options = {
        signcolumn = "yes:2",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
  },
}
