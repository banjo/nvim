return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>A", group = "aider" },
        { "<leader>gd", group = "diffview" },
        { "<leader>h", desc = "Arrow" },
        { "<leader>gx", desc = "Git Conflict" },
      },
    },
  },
}
