return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    { "<leader>Aa", "<cmd>Aider toggle<cr>", desc = "Toggle" },
    { "<leader>As", "<cmd>Aider send<cr>", desc = "Send", mode = { "n", "v" } },
    { "<leader>Ac", "<cmd>Aider command<cr>", desc = "Command" },
    { "<leader>Ab", "<cmd>Aider buffer<cr>", desc = "Buffer" },
    { "<leader>A+", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>A-", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>Ar", "<cmd>Aider addReadonly<cr>", desc = "Add Read-Only" },
    { "<leader>AR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
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
