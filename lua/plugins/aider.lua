return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    { "<leader>Aa", "<cmd>Aider toggle<cr>", desc = "toggle [a]ider" },
    { "<leader>As", "<cmd>Aider send<cr>", desc = "[s]end to [a]ider", mode = { "n", "v" } },
    { "<leader>Ac", "<cmd>Aider command<cr>", desc = "[c]ommand [a]ider" },
    { "<leader>Ab", "<cmd>Aider buffer<cr>", desc = "[b]uffer [a]ider" },
    { "<leader>A+", "<cmd>Aider add<cr>", desc = "[a]dd file to [a]ider" },
    { "<leader>A-", "<cmd>Aider drop<cr>", desc = "[d]rop file from [a]ider" },
    { "<leader>Ar", "<cmd>Aider addReadonly<cr>", desc = "add [r]ead-only" },
    { "<leader>AR", "<cmd>Aider reset<cr>", desc = "[R]eset [a]ider session" },
  },
  dependencies = {
    "folke/snacks.nvim",
    "catppuccin/nvim",
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        opts.window = {
          mappings = {
            ["+"] = { "nvim_aider_add", desc = "add to aider" },
            ["-"] = { "nvim_aider_drop", desc = "drop from aider" },
            ["="] = { "nvim_aider_add_read_only", desc = "add read-only to aider" },
          },
        }
        require("nvim_aider.neo_tree").setup(opts)
      end,
    },
  },
  config = true,
}
