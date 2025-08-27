return {
  "GeorgesAlkhouri/nvim-aider",
  enabled = false,
  cmd = "Aider",
  keys = {
    { "<leader>Aa", "<cmd>Aider toggle<cr>", desc = "Toggle Aider panel" },
    { "<leader>As", "<cmd>Aider send<cr>", desc = "Send selection to Aider", mode = { "n", "v" } },
    { "<leader>Ac", "<cmd>Aider command<cr>", desc = "Run Aider command" },
    { "<leader>Ab", "<cmd>Aider buffer<cr>", desc = "Send buffer to Aider" },
    { "<leader>A+", "<cmd>Aider add<cr>", desc = "Add file to Aider session" },
    { "<leader>A-", "<cmd>Aider drop<cr>", desc = "Remove file from Aider session" },
    { "<leader>Ar", "<cmd>Aider addReadonly<cr>", desc = "Add file as read-only" },
    { "<leader>AR", "<cmd>Aider reset<cr>", desc = "Reset Aider session" },
  },
  dependencies = {
    "folke/snacks.nvim",
    "catppuccin/nvim",
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        opts.window = {
          mappings = {
            ["+"] = { "nvim_aider_add", desc = "Add to Aider" },
            ["-"] = { "nvim_aider_drop", desc = "Drop from Aider" },
            ["="] = { "nvim_aider_add_read_only", desc = "Add Read-Only to Aider" },
          },
        }
        require("nvim_aider.neo_tree").setup(opts)
      end,
    },
  },
  config = true,
}
