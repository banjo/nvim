return {
  {
    "folke/which-key.nvim",
    opts = {
      win = {
        height = {
          max = math.huge,
        },
      },
      preset = "modern",
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>A", group = "aider" },
        { "<leader>gd", group = "diffview" },
        { "<leader>h", desc = "Arrow" },
        { "<leader>gx", desc = "Git Conflict" },
        { "<leader>sa", desc = "Search Auto Commands", hidden = true },
        { "<leader>sc", desc = "Search Command History", hidden = true },
        { "<leader>sC", desc = "Search Commands", hidden = true },
        { "<leader>sD", desc = "Search Workspace Diagnostics", hidden = true },
        { "<leader>se", desc = "Search Explorer Files", hidden = true },
        { "<leader>sh", desc = "Search Help Pages", hidden = true },
        { "<leader>sH", desc = "Search Highlight Groups", hidden = true },
        { "<leader>sk", desc = "Search Key Maps", hidden = true },
        { "<leader>sM", desc = "Search Man Pages", hidden = true },
        { "<leader>sm", desc = "Search Mark to Jump", hidden = true },
        { "<leader>so", desc = "Search Options", hidden = true },
        { "<leader>s\"", desc = "Search Registers", hidden = true },
        { "<leader>sS", desc = "Search Symbols Workspace", hidden = true },
        { "<leader>sj", desc = "Jumplist", hidden = true },
        { "<leader>sl", desc = "Location List", hidden = true },
      },
    },
  },
}
